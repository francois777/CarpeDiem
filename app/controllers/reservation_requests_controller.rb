class ReservationRequestsController < ApplicationController

  before_action :set_reservation_request, only: [:show, :edit, :update]
  before_action :set_types, only: [:new, :edit]

  def new
    @reservation_request = ReservationRequest.new
    @unavailable_facilities = []
  end

  def create
    @reservation_request = ReservationRequest.new(request_params)
    @unavailable_facilities = []
    if @reservation_request.valid?
      @unavailable_facilities = list_unavailable_facility_types
      puts "Unavailable facilities: #{@unavailable_facilities.to_s}"
      if @unavailable_facilities.empty?
        @reservation_request.status = 'Pending'
        #  Fill in missing reservation fields 
        #  Build submit and edit methods
        #  Build development seeds
        if @reservation_request.save
          flash[:success] = t(:reservation_request_created, scope: [:success])
          redirect_to edit_reservation_request_path(@reservation_request)
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

  def submit
  end

  def show
  end

  def edit
    puts "ReservationRequestsController#edit"
    # Calculate prices
    #  Tariff.find_current_tariff(tariff_category, price_class)
    # Facility 1
    #  facility_type_1
    @unavailable_facilities = []
  end

  def update
  end

  private

    # def list_unavailable_facility_types
    #   facility_types = []
    #   facility_type = ReservationRequest.index_to_name(@reservation_request.facility_type_1)
    #   facility_types << facility_type
    #   unavailable_facilities = []
    #   unless is_available?(facility_type, 
    #                        @reservation_request.start_date_1, 
    #                        @reservation_request.end_date_1)
    #     puts "#{facility_type} is not available between #{@reservation_request.start_date_1.to_s} and #{@reservation_request.end_date_1.to_s}"
    #     unavailable_facilities << facility_type
    #   end  
    #   if @reservation_request.start_date_2.is_a?(Date)
    #     facility_type = ReservationRequest.index_to_name(@reservation_request.facility_type_2)
    #     unless facility_types.include? facility_type
    #       unless is_available?(@reservation_request.facility_type_2, 
    #                                           @reservation_request.start_date_2, 
    #                                           @reservation_request.end_date_2)
    #         puts "#{facility_type} is not available between #{@reservation_request.start_date_2.to_s} and #{@reservation_request.end_date_2.to_s}"
    #         unavailable_facilities << facility_type
    #       end
    #     end  
    #   end  
    #   if @reservation_request.start_date_3.is_a?(Date)
    #     facility_type = ReservationRequest.index_to_name(@reservation_request.facility_type_3)
    #     unless facility_types.include? facility_type
    #       unless is_available?(@reservation_request.facility_type_3, 
    #                                           @reservation_request.start_date_3, 
    #                                           @reservation_request.end_date_3)
    #         puts "#{facility_type} is not available between #{@reservation_request.start_date_3.to_s} and #{@reservation_request.end_date_3.to_s}"
    #         unavailable_facilities << facility_type
    #       end
    #     end
    #   end
    #   unavailable_facilities
    # end

    # def is_available?(facility_type, start_date, end_date)
    #   # puts "ReservationRequestsController#is_available"
    #   count = case facility_type
    #   when 'Tent'
    #     Tent.available_count_between(start_date, end_date)
    #   when 'Caravan'
    #     Caravan.available_count_between(start_date, end_date)
    #   when 'Chalet_Small'
    #     0
    #   when 'Chalet_Medium'
    #     0
    #   when 'Chalet_Large'
    #     0
    #   else
    #     0
    #   end
    #   count > 0
    # end

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
end
