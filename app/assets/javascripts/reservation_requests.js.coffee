$(".reservation_requests.show").ready ->
  initRequestPage()

$(".reservation_requests.new").ready ->
  initRequestPage()

$(".reservation_requests.edit").ready ->
  initRequestPage()

initRequestPage = (e) ->
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
    alert "Entering toggleFacility2"
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
    if dte.length != 0
      start_dte = dte[0].value
      if start_dte != ""
        checkbox = $("#Second_facility_required_")
        checkbox.checked = true
        $("#second-facility").show()

  displayFacility3 = (e) ->
    dte = $('#reservation_request_start_date_3')
    if dte.length != 0
      start_dte = dte[0].value
      if start_dte != ""
        checkbox = $("#Third_facility_required_")
        checkbox.checked = true
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