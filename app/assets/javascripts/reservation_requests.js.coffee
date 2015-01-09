$("section.reservation-request").ready ->
  # alert "My coffeescript is being executed"
  $('#reservation_request_start_date_1').datepicker
    dateFormat: "dd M yy"
  $('#reservation_request_end_date_1').datepicker
    dateFormat: "dd M yy"
  $('#reservation_request_start_date_2').datepicker
    dateFormat: "dd M yy"
  $('#reservation_request_end_date_2').datepicker
    dateFormat: "dd M yy"
  $('#reservation_request_start_date_3').datepicker
    dateFormat: "dd M yy"
  $('#reservation_request_end_date_3').datepicker
    dateFormat: "dd M yy"

  $("#second-facility").hide()
  $("#third-facility").hide()
  
  toggleFacility2 = (e) ->
    checkbox = $("#Second_facility_required_")
    checked = checkbox.is(":checked")
    if checked
      # alert "The checkbox is checked"
      $("#second-facility").show()
    else
      # alert "The checkbox is unchecked"
      $("#second-facility").hide()

  toggleFacility3 = (e) ->
    checkbox = $("#Third_facility_required_")
    checked = checkbox.is(":checked")
    if checked
      # alert "The checkbox is checked"
      $("#third-facility").show()
    else
      # alert "The checkbox is unchecked"
      $("#third-facility").hide()

  displayFacility2 = (e) ->
    dte = $('#reservation_request_start_date_2')
    if (typeof dte is "object")
      checkbox = $("#Second_facility_required_")
      checked = checkbox.is(":checked")
      $("#second-facility").show()

  displayFacility3 = (e) ->
    dte = $('#reservation_request_start_date_3')
    if typeof dte is "object"
      checkbox = $("#Third_facility_required_")
      checked = checkbox.is(":checked")
      $("#third-facility").show()

  $('#Second_facility_required_').click(toggleFacility2)
  $('#Third_facility_required_').click(toggleFacility3)
  displayFacility2()
  displayFacility3()


###
http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
http://brandonhilkert.com/blog/page-specific-javascript-in-rails/
http://theflyingdeveloper.com/controller-specific-assets-with-rails-4/

###