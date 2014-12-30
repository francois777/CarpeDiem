class ReservationRequestsController < ApplicationController

  before_action :set_reservation_request, only: [:show, :edit, :update]
  before_action :set_types, only: [:new, :edit]

  def new
    puts "ReservationRequestsController#new"
    @reservation_request = ReservationRequest.new
    @unavailable_facilities = []
  end

  def create
    @reservation_request = ReservationRequest.new(request_params)
    @unavailable_facilities = []
    if @reservation_request.valid?
      @unavailable_facilities = find_unavailable_facilities
      if @unavailable_facilities.empty?
        puts "About to save a reservation_request"
        if @reservation_request.save
          puts "Save succeeded"
          flash[:success] = t(:reservation_request_created, scope: [:success])
          redirect_to edit_reservation_request_path(@reservation_request)
        else
          puts "Save was not successful"
          flash[:alert] = t(:reservation_request_create_failed, scope: [:failure])
        end
      else
        puts "Unavailable facilities alert"
        flash[:alert] = t(:some_facilities_fully_booked, scope: [:failure])
      end  
    else
      puts "Reservation Request not valid"
      flash[:alert] = t(:reservation_request_create_failed, scope: [:failure])
    end
    set_types
    puts "Rendering 'new' template"
    puts "\nErrors:"
    puts @reservation_request.errors.inspect
    render :new
  end

  def edit
  end

  def update
  end

  private

    def find_unavailable_facilities
      puts "\nFinding unavailable facilities"
      facilities = []
      unless is_available?(@reservation_request.facility_type_1, 
                                          @reservation_request.start_date_1, 
                                          @reservation_request.end_date_1)
        facilities << 1
      end  
      if @reservation_request.start_date_2.is_a?(Date)
        unless is_available?(@reservation_request.facility_type_2, 
                                            @reservation_request.start_date_2, 
                                            @reservation_request.end_date_2)
          facilities << 2
        end
      end  
      if @reservation_request.start_date_3.is_a?(Date)
        unless is_available?(@reservation_request.facility_type_3, 
                                            @reservation_request.start_date_3, 
                                            @reservation_request.end_date_3)
          facilities << 3
        end
      end
      facilities
    end

    def is_available?(facility_type, start_date, end_date)
      false
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
end
