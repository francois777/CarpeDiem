class ReservationRequestsController < ApplicationController

  include ReservationRequestsHelper

  before_action :set_reservation_request, only: [:show, :edit, :update]
  before_action :set_types, only: [:new, :edit]

  def new
    @reservation_request = ReservationRequest.new
    @unavailable_facilities = []
    initialise_counters
  end

  def create
    @reservation_request = ReservationRequest.new(request_params)
    initialise_counters
    @unavailable_facilities = []
    if @reservation_request.valid?
      @unavailable_facilities = list_unavailable_facility_types
      puts "Unavailable facilities: #{@unavailable_facilities.to_s}"
      if @unavailable_facilities.empty?
        @reservation_request.status = 'Pending'
        if @reservation_request.save
          initialise_counters
          calculate_facility_costs
          flash[:success] = t(:reservation_request_created, scope: [:success])
          redirect_to edit_reservation_request_path(@reservation_request, amount_params)
          return
        else
          flash[:alert] = t(:reservation_request_create_failed, scope: [:failure])
        end
      else
        flash[:alert] = t(:some_facilities_fully_booked, scope: [:failure])
      end  
    else
      flash[:alert] = t(:reservation_request_create_failed, scope: [:failure])
    end
    set_types
    render :new
  end

  def update
    #puts "ReservationRequestsController#update"
    unless @reservation_request.reservation_reference_id.nil?
      flash[:alert] = t(:unauthorised_action_update_not_allowed)
      redirect_to root_path
    end  

    @unavailable_facilities = []
    if @reservation_request.valid?
      @unavailable_facilities = list_unavailable_facility_types
      if @unavailable_facilities.empty?
        if @reservation_request.update_attributes(request_params)
          initialise_counters
          calculate_facility_costs
          if params['update'] == 'Save and Review'
            flash[:success] = t(:reservation_request_updated, scope: [:success])
            redirect_to edit_reservation_request_path(@reservation_request, amount_params)
            return
          end
          if params['update'] == 'Submit Request'  
            if @reservation_request.reservation_reference_id.nil? 
              reservation = Reservation.new( new_reservation_params )
              unless reservation.valid?
                flash[:alert] = t(:reservation_request_update_failed, scope: [:failure])
                redirect_to edit_reservation_request_path(@reservation_request, amount_params)
                return
              end
              reservation.save
              @reservation_request.reservation_reference_id = reservation.reload.reservation_reference.refid
              @reservation_request.status = 'Submitted'
              @reservation_request.save
              redirect_to reservation_request_path(@reservation_request, amount_params,
                request_number: reservation.reservation_reference.refid )
              return
            end
          end
        else
          flash[:alert] = t(:reservation_request_update_failed, scope: [:failure])
        end
      else
        # Some requested facilities are unavailable
        flash[:alert] = t(:some_facilities_fully_booked, scope: [:failure])
      end  
    else
      flash[:alert] = t(:reservation_request_create_failed, scope: [:failure])
    end
    set_types
    render :edit
  end

  def show
    if params.has_key?('request_number') && params['request_number'].to_i == @reservation_request.reservation_reference_id && @reservation_request.status == 'Submitted'
      @unavailable_facilities = list_unavailable_facility_types
      initialise_counters
      calculate_facility_costs
    else
      redirect_to root_path
    end  
  end

  def edit
    @adult_amount_1 = params['adult_amount_1'].to_i
    @teenagers_amount_1 = params['teenagers_amount_1'].to_i
    @children_amount_1 = params['children_amount_1'].to_i
    @total_amount_1 = params['total1'].to_i
    @adult_amount_2 = params['adult_amount_2'].to_i
    @teenagers_amount_2 = params['teenagers_amount_2'].to_i
    @children_amount_2 = params['children_amount_2'].to_i
    @total_amount_2 = params['total2'].to_i
    @adult_amount_3 = params['adult_amount_3'].to_i
    @teenagers_amount_3 = params['teenagers_amount_3'].to_i
    @children_amount_3 = params['children_amount_3'].to_i
    @total_amount_3 = params['total3'].to_i
    @unavailable_facilities = []
  end

  private

    def amount_params
      { adult_amount_1: @adult_amount_1, teenagers_amount_1: @teenagers_amount_1,
        children_amount_1: @children_amount_1, total1: @total_amount_1,
        adult_amount_2: @adult_amount_2, teenagers_amount_2: @teenagers_amount_2,
        children_amount_2: @children_amount_2, total2: @total_amount_2,
        adult_amount_3: @adult_amount_3, teenagers_amount_3: @teenagers_amount_3,
        children_amount_3: @children_amount_3, total3: @total_amount_3 }
    end

    def new_reservation_params
      { start_date: @reservation_request.start_date_1,
        end_date: @reservation_request.end_date_1,
        reserved_for_name: @reservation_request.applicant_name,
        reserved_datetime: Time.now,
        telephone: @reservation_request.applicant_telephone,
        mobile: @reservation_request.applicant_mobile,
        email: @reservation_request.applicant_email,
        town: @reservation_request.applicant_town,
        meals_required: false,
        invoiced_amount: @total_amount_1 + @total_amount_2 + @total_amount_3,
        key_deposit_received: 0,
        vehicle_registration_numbers: @reservation_request.vehicle_registration_numbers,
        comments: @reservation_request.special_requests,
        status: 'Pending' }
    end

    def request_params
      params.require(:reservation_request).permit(:applicant_name, :applicant_telephone,
        :applicant_mobile, :applicant_email, :applicant_town, :facility_type_1,
        :start_date_1, :end_date_1, :adults_18_plus_count_1, :teenagers_count_1,
        :children_6_12_count_1, :infants_count_1, :power_point_required_1,
        :facility_type_2, :start_date_2, :end_date_2, :adults_18_plus_count_2,
        :teenagers_count_2, :children_6_12_count_2, :infants_count_2,
        :power_point_required_2, :facility_type_3, :start_date_3, :end_date_3,
        :adults_18_plus_count_3, :teenagers_count_3, :children_6_12_count_3,
        :infants_count_3, :power_point_required_3, :meals_required_count,
        :vehicle_registration_numbers, :payable_amount, :key_deposit_amount,
        :estimated_arrival_time, :special_requests
        )
    end

    def set_reservation_request
      @reservation_request = ReservationRequest.find(params[:id].to_i)
    end

    def set_types
      @facility_types = I18n.t(:facility_types).each_with_index.map { |fType, inx| [fType[1].to_s, inx] }
    end

    def calculate_facility_costs
      calculate_cost_for_facility_1
      calculate_cost_for_facility_2 if @reservation_request.start_date_2.is_a? Time
      calculate_cost_for_facility_3 if @reservation_request.start_date_3.is_a? Time
    end

    def calculate_cost_for_facility_1
      dte_from = @reservation_request.start_date_1
      dte_until = @reservation_request.end_date_1
      powered = @reservation_request.power_point_required_1
      adult_tariff = Tariff.adult_tariff(@reservation_request.facility_type_1, dte_from, dte_until, powered)
      @adult_amount_1 = @reservation_request.adults_18_plus_count_1 * adult_tariff
      @teenagers_amount_1 = @reservation_request.teenagers_count_1 * adult_tariff
      @children_amount_1 = (@reservation_request.children_6_12_count_1 * adult_tariff * (1 - @settings.child_discount_percentage)).round
      @total_amount_1 = @adult_amount_1 + @teenagers_amount_1 + @children_amount_1
    end

    def calculate_cost_for_facility_2
      dte_from = @reservation_request.start_date_2
      dte_until = @reservation_request.end_date_2
      powered = @reservation_request.power_point_required_2
      adult_tariff = Tariff.adult_tariff(@reservation_request.facility_type_2, dte_from, dte_until, powered)
      @adult_amount_2 = @reservation_request.adults_18_plus_count_2 * adult_tariff
      @teenagers_amount_2 = @reservation_request.teenagers_count_2 * adult_tariff
      @children_amount_2 = (@reservation_request.children_6_12_count_2 * adult_tariff * (1 - @settings.child_discount_percentage)).round
      @total_amount_2 = @adult_amount_2 + @teenagers_amount_2 + @children_amount_2
    end

    def calculate_cost_for_facility_3
      dte_from = @reservation_request.start_date_3
      dte_until = @reservation_request.end_date_3
      powered = @reservation_request.power_point_required_3
      adult_tariff = Tariff.adult_tariff(@reservation_request.facility_type_3, dte_from, dte_until, powered)
      @adult_amount_3 = @reservation_request.adults_18_plus_count_3 * adult_tariff
      @teenagers_amount_3 = @reservation_request.teenagers_count_3 * adult_tariff
      @children_amount_3 = (@reservation_request.children_6_12_count_3 * adult_tariff * (1 - @settings.child_discount_percentage)).round
      @total_amount_3 = @adult_amount_3 + @teenagers_amount_3 + @children_amount_3
    end

    def initialise_counters
      @adult_amount_1 = 0
      @teenagers_amount_1 = 0
      @children_amount_1 = 0
      @total_amount_1 = 0
      @adult_amount_2 = 0
      @teenagers_amount_2 = 0
      @children_amount_2 = 0
      @total_amount_2 = 0
      @adult_amount_3 = 0
      @teenagers_amount_3 = 0
      @children_amount_3 = 0
      @total_amount_3 = 0
    end
end
