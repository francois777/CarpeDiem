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
    $("#second-facility").show()
  $('#Second_facility_required_').click(toggleFacility2)
  toggleFacility3 = (e) ->
    $("#third-facility").show()
  $('#Third_facility_required_').click(toggleFacility3)

###
http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
http://brandonhilkert.com/blog/page-specific-javascript-in-rails/
http://theflyingdeveloper.com/controller-specific-assets-with-rails-4/
###