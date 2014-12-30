jQuery ->
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
