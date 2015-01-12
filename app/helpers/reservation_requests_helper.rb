module ReservationRequestsHelper

  def list_unavailable_facility_types
    # puts "ReservationRequestsHelper#list_unavailable_facility_types"
    # puts "Facility type 1: #{@reservation_request.facility_type_1}"
    facility_types = []
    facility_type = ReservationRequest.index_to_name(@reservation_request.facility_type_1)
    facility_types << facility_type
    unavailable_facilities = []
    unless is_available?(facility_type, 
                         @reservation_request.start_date_1, 
                         @reservation_request.end_date_1)
      puts "#{facility_type} is not available between #{@reservation_request.start_date_1.to_s} and #{@reservation_request.end_date_1.to_s}"
      unavailable_facilities << facility_type
    end  
    if @reservation_request.start_date_2.is_a?(Date)
      facility_type = ReservationRequest.index_to_name(@reservation_request.facility_type_2)
      unless facility_types.include? facility_type
        unless is_available?(@reservation_request.facility_type_2, 
                                            @reservation_request.start_date_2, 
                                            @reservation_request.end_date_2)
          puts "#{facility_type} is not available between #{@reservation_request.start_date_2.to_s} and #{@reservation_request.end_date_2.to_s}"
          unavailable_facilities << facility_type
        end
      end  
    end  
    if @reservation_request.start_date_3.is_a?(Date)
      facility_type = ReservationRequest.index_to_name(@reservation_request.facility_type_3)
      unless facility_types.include? facility_type
        unless is_available?(@reservation_request.facility_type_3, 
                                            @reservation_request.start_date_3, 
                                            @reservation_request.end_date_3)
          puts "#{facility_type} is not available between #{@reservation_request.start_date_3.to_s} and #{@reservation_request.end_date_3.to_s}"
          unavailable_facilities << facility_type
        end
      end
    end
    unavailable_facilities
  end

  def is_available?(facility_type, start_date, end_date)
    # puts "ReservationRequestsController#is_available"
    count = case facility_type
    when 'Tent'
      Tent.available_count_between(start_date, end_date)
    when 'Caravan'
      Caravan.available_count_between(start_date, end_date)
    when 'Chalet_Small', 'Chalet_Medium', 'Chalet_Large'
      Chalet.available_count_between(facility_type, start_date, end_date)
    else
      0
    end
    count > 0 
  end
  
end