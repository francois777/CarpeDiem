// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
  console.log("Inside ready function");
  // $("#edit_season_detail_line_16.form-group.col-sm-8.col-sm-6.dropdown ul.dropdown-menu li a").on("click"), function() {
  $("ul.dropdown-menu li a").on("click", function() {
    console.log("a click event detected");
    console.log("Link id is " + this.getAttribute('id'));
    console.log(this.text.trim());
    var textField = this.parentNode.parentNode.parentNode.parentNode.parentNode.children[0].children[0];
    textField.value = this.text.trim();
    // console.log("ancestor class name: " + ancestor.className);
    // var text_field = anc
    // console.log(ancestor.children[0].value);
    
  });
  // $("#16-0").on("click", function() {
  // });
});