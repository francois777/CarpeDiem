# $(".camping_sites.index").ready ->

$(".filter").change(function(){
  var value = $(this).val()
  $.ajax({
    url: admin_camping_sites_path('json'),
    type: 'GET',
    data: value,
    success: function(data){
      $("#site_list").html(data.camping_sites)
    }
  })
})
