class ReservationEnquiryPdf < Prawn::Document

  include ApplicationHelper

  def initialize(reservation_request, costs, view)
    super()
    @reservation_request = reservation_request
    @costs = costs
    @view = view
    # stroke_axis
    logo
    letter_start
    print_applicant_details
    print_facility1
    print_facility2 if @reservation_request.start_date_2.is_a? Time
    # learn
    
  end

  def learn
    stroke_axis
    # stroke_circle [0, 0], 10
    # bounding_box([100, 300], :width => 300, :height => 200) do
    #   stroke_bounds
    #   col_width = 150
    #   float do
    #     text "In the bounding box"
    #     text "Still in the box"
    #   end
    # end
    # stroke do
    #   vertical_line 150, 300, :at => 50
    #   horizontal_line 200, 450, :at => 150
    # end
    move_cursor_to 50
    text "This text will flow to the next page. " * 20
    text "The value of 'cursor' is now #{cursor}. The next text will start at cursor - 50."
    stroke_axis

    y_position = cursor - 50
    bounding_box([0, y_position], :width => 200, :height => 150) do
      transparent(0.5) { stroke_bounds }
      text "This text will flow along this bounding box we created for it. " * 5
    end

    bounding_box([300, y_position], :width => 200, :height => 150) do
      transparent(0.5) { stroke_bounds } # This will stroke on one page
      text "Now look what happens when the free flowing text reaches the end " +
        "of a bounding box that is narrower than the margin box." +
        " . " * 200 +
        "It continues on the next page as if the previous bounding box " +
        "was cloned. If we want it to have the same border as the one on " +
        "the previous page we will need to stroke the boundaries again."
      transparent(0.5) { stroke_bounds } # And this will stroke on the next
    end
    stroke_axis

    move_cursor_to 200
    span(350, :position => :center) do
      text "Span is a different kind of bounding box as it lets the text " +
         "flow gracefully onto the next page. It doesn't matter if the text " +
         "started on the middle of the previous page, when it flows to the " +
         "next page it will start at the beginning." + " _ " * 500 +
         "I told you it would start on the beginning of this page."
    end
  end

  def print_applicant_details
    applicant_details = [
      { label: I18n.t(:applicant_name, scope: [:reservation_requests, :applicant_details]),
        data: @reservation_request.applicant_name },
      { label: I18n.t(:applicant_telephone, scope: [:reservation_requests, :applicant_details]),
        data: @reservation_request.applicant_telephone },
      { label: I18n.t(:applicant_mobile, scope: [:reservation_requests, :applicant_details]),
        data: @reservation_request.applicant_mobile },
      { label: I18n.t(:applicant_email, scope: [:reservation_requests, :applicant_details]),
        data: @reservation_request.applicant_email },
      { label: I18n.t(:applicant_town, scope: [:reservation_requests, :applicant_details]),
        data: @reservation_request.applicant_town }, 
      { label: I18n.t(:vehicle_registration_numbers, scope: [:reservation_requests, :applicant_details]),
        data: @reservation_request.vehicle_registration_numbers }        
    ]
    move_cursor_to 440
    text I18n.t(:applicant_details, scope: [:reservation_requests, :applicant_details]).upcase, :color => "0000FF"
    ypos = 410
    font("Helvetica", :size => 11) do
      applicant_details.each_with_index do |line, inx|
        draw_text line[:label], :at => [50, ypos - (inx * 16)], :style => :bold
        draw_text line[:data], :at => [200, ypos - (inx * 16)]
      end
    end
  end

  def print_facility1
    facility_details = [
      { label: I18n.t(:facility_type_1, scope: [:reservation_requests, :fields1]),
        data: ReservationRequest::FACILITY_TYPES[@reservation_request.facility_type_1] },
      { label: I18n.t(:start_date_1, scope: [:reservation_requests, :fields1]),
        data: display_date(@reservation_request.start_date_1) },
      { label: I18n.t(:end_date_1, scope: [:reservation_requests, :fields1]),
        data: display_date(@reservation_request.end_date_1) }
    ]
    if @reservation_request.power_point_required_1
      facility_details << { 
        label: I18n.t(:power_point_required_1, scope: [:reservation_requests, :fields1]),
        data: 'Yes'
      } 
    end
    facility_details << { 
      label: I18n.t(:adults_18_plus_count_1, scope: [:reservation_requests, :fields1]),
      data: @reservation_request.adults_18_plus_count_1,
      price: to_local_currency(@costs[0][:adult_amount])
      } if @reservation_request.adults_18_plus_count_1 > 0
    facility_details << { 
      label: I18n.t(:teenagers_count_1, scope: [:reservation_requests, :fields1]),
      data: @reservation_request.teenagers_count_1,
      price: to_local_currency(@costs[0][:teenagers_amount])
      } if @reservation_request.teenagers_count_1 > 0
    facility_details << { 
      label: I18n.t(:children_6_12_count_1, scope: [:reservation_requests, :fields1]),
      data: @reservation_request.children_6_12_count_1,
      price: to_local_currency(@costs[0][:teenagers_amount])
      } if @reservation_request.children_6_12_count_1 > 0
    facility_details << { 
      label: I18n.t(:infants_count_1, scope: [:reservation_requests, :fields1]),
      data: @reservation_request.infants_count_1,
      price: to_local_currency(0)
      } if @reservation_request.infants_count_1 > 0
    facility_details << { 
      label: I18n.t(:total_amount, scope: [:global]),
      data: "",
      total: to_local_currency(@costs[0][:total_amount])
      } if @costs[0][:total_amount] > 0

    move_cursor_to 310
    heading = I18n.t(:accommodation, scope: [:global]).upcase
    text "#{heading} (1)", :color => "0000FF"
    ypos = 280
    font("Helvetica", :size => 11) do
      facility_details.each_with_index do |line, inx|
        draw_text line[:label], :at => [50, ypos - (inx * 16)], :style => :bold
        draw_text line[:data], :at => [200, ypos - (inx * 16)]
        if line[:price] 
          text_box line[:price], :at => [250, ypos - (inx * 16) + 10], :width => 70, :height => 20, :align => :right
        end
        if line[:total] 
          stroke_line [250, ypos - (inx * 16) + 12], [320, ypos - (inx * 16) + 12]
          text_box line[:total], :at => [250, ypos - (inx * 16) + 8], :width => 70, :height => 20, :align => :right, :style => :bold, :size => 14
        end
      end
    end
  end

  def print_facility2
    facility_details = [
      { label: I18n.t(:facility_type_2, scope: [:reservation_requests, :fields2]),
        data: ReservationRequest::FACILITY_TYPES[@reservation_request.facility_type_2] },
      { label: I18n.t(:start_date_2, scope: [:reservation_requests, :fields2]),
        data: display_date(@reservation_request.start_date_2) },
      { label: I18n.t(:end_date_2, scope: [:reservation_requests, :fields2]),
        data: display_date(@reservation_request.end_date_2) }
    ]
    if @reservation_request.power_point_required_2
      facility_details << { 
        label: I18n.t(:power_point_required_2, scope: [:reservation_requests, :fields2]),
        data: 'Yes'
      } 
    end
    facility_details << { 
      label: I18n.t(:adults_18_plus_count_2, scope: [:reservation_requests, :fields2]),
      data: @reservation_request.adults_18_plus_count_2,
      price: to_local_currency(@costs[1][:adult_amount])
      } if @reservation_request.adults_18_plus_count_2 > 0
    facility_details << { 
      label: I18n.t(:teenagers_count_2, scope: [:reservation_requests, :fields2]),
      data: @reservation_request.teenagers_count_2,
      price: to_local_currency(@costs[1][:teenagers_amount])
      } if @reservation_request.teenagers_count_2 > 0
    facility_details << { 
      label: I18n.t(:children_6_12_count_2, scope: [:reservation_requests, :fields2]),
      data: @reservation_request.children_6_12_count_2,
      price: to_local_currency(@costs[1][:teenagers_amount])
      } if @reservation_request.children_6_12_count_2 > 0
    facility_details << { 
      label: I18n.t(:infants_count_2, scope: [:reservation_requests, :fields2]),
      data: @reservation_request.infants_count_2,
      price: to_local_currency(0)
      } if @reservation_request.infants_count_2 > 0
    facility_details << { 
      label: I18n.t(:total_amount, scope: [:global]),
      data: "",
      total: to_local_currency(@costs[1][:total_amount])
      } if @costs[1][:total_amount] > 0
    move_cursor_to 140
    heading = I18n.t(:accommodation, scope: [:global]).upcase
    text "#{heading} (2)", :color => "0000FF"
    ypos = 110
    font("Helvetica", :size => 11) do
      facility_details.each_with_index do |line, inx|
        draw_text line[:label], :at => [50, ypos - (inx * 16)], :style => :bold
        draw_text line[:data], :at => [200, ypos - (inx * 16)]
        if line[:price] 
          text_box line[:price], :at => [250, ypos - (inx * 16) + 10], :width => 70, :height => 20, :align => :right
        end
        if line[:total] 
          stroke_line [250, ypos - (inx * 16) + 12], [320, ypos - (inx * 16) + 12]
          text_box line[:total], :at => [250, ypos - (inx * 16) + 8], :width => 70, :height => 20, :align => :right, :style => :bold, :size => 14
        end
      end
    end
  end

  def print_facility3
    facility_details = [
      { label: I18n.t(:facility_type_3, scope: [:reservation_requests, :fields3]),
        data: ReservationRequest::FACILITY_TYPES[@reservation_request.facility_type_3] },
      { label: I18n.t(:start_date_3, scope: [:reservation_requests, :fields3]),
        data: display_date(@reservation_request.start_date_3) },
      { label: I18n.t(:end_date_3, scope: [:reservation_requests, :fields3]),
        data: display_date(@reservation_request.end_date_3) }
    ]
    if @reservation_request.power_point_required_3
      facility_details << { 
        label: I18n.t(:power_point_required_3, scope: [:reservation_requests, :fields3]),
        data: 'Yes'
      } 
    end
    facility_details << { 
      label: I18n.t(:adults_18_plus_count_3, scope: [:reservation_requests, :fields3]),
      data: @reservation_request.adults_18_plus_count_3,
      price: to_local_currency(@costs[1][:adult_amount])
      } if @reservation_request.adults_18_plus_count_3 > 0
    facility_details << { 
      label: I18n.t(:teenagers_count_3, scope: [:reservation_requests, :fields3]),
      data: @reservation_request.teenagers_count_3,
      price: to_local_currency(@costs[1][:teenagers_amount])
      } if @reservation_request.teenagers_count_3 > 0
    facility_details << { 
      label: I18n.t(:children_6_12_count_3, scope: [:reservation_requests, :fields3]),
      data: @reservation_request.children_6_12_count_3,
      price: to_local_currency(@costs[1][:teenagers_amount])
      } if @reservation_request.children_6_12_count_3 > 0
    facility_details << { 
      label: I18n.t(:infants_count_3, scope: [:reservation_requests, :fields3]),
      data: @reservation_request.infants_count_3,
      price: to_local_currency(0)
      } if @reservation_request.infants_count_3 > 0
    facility_details << { 
      label: I18n.t(:total_amount, scope: [:global]),
      data: "",
      total: to_local_currency(@costs[2][:total_amount])
      } if @costs[1][:total_amount] > 0
    move_cursor_to 150
    heading = I18n.t(:accommodation, scope: [:global]).upcase
    text "#{heading} (3)", :color => "0000FF"
    ypos = 120
    font("Helvetica", :size => 12) do
      facility_details.each_with_index do |line, inx|
        draw_text line[:label], :at => [50, ypos - (inx * 16)], :style => :bold
        draw_text line[:data], :at => [200, ypos - (inx * 16)]
        if line[:price] 
          text_box line[:price], :at => [250, ypos - (inx * 16) + 10], :width => 70, :height => 20, :align => :right
        end
        if line[:total] 
          stroke_line [250, ypos - (inx * 16) + 12], [320, ypos - (inx * 16) + 12]
          text_box line[:total], :at => [250, ypos - (inx * 16) + 8], :width => 70, :height => 20, :align => :right, :style => :bold, :size => 14
        end
      end
    end
  end

  def logo
    logopath = "#{Rails.root}/app/assets/images/logo.png"
    image logopath, :width => 316, :height => 141
  end

  def letter_start
    move_down 20
    font("Helvetica", :size => 11) do
      text display_date(@reservation_request.created_at)
      move_down 15
      text "Dear #{@reservation_request.applicant_name},"
      move_down 15
      text "Thank you for showing interest to visit us at Carpe Diem! Your " +
           "reference number for this enquiry is #{@reservation_request.reservation_reference_id}. "
      move_down 10
      text "Within 3 working days we will confirm if we are able to provide " +
           "accommodation meeting your requirements."
    end
  end

end