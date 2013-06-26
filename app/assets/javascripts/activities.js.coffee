# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_activity_select').click ->
    $('#new_activity').slideToggle()
$ ->
  if (window.location.pathname.match(/activities/))
    format_activity_form()

$ ->    
  $('#activity_activitycategory_id').change ->
    format_activity_form()

$ ->
  if (window.location.pathname.match(/works\//))
    format_activity_form()

format_activity_form = () ->
  location = window.location.pathname
  console.log(location)
  $('#venue').hide()
  $('#client').hide()
  $('#date').hide()
  $('#start_date').hide()
  $('#end_date').hide()
  $('#work').hide()

  category = $('#activity_activitycategory_id :selected').text()
  $('#venue').hide()
  $('#client').hide()
  $('#date').hide()
  $('#end_date').hide()
  $('#work').hide()
  $('#date').addClass('span3')
  $('#date').removeClass('span4')
  $('#client').addClass('span4')
  $('#client').removeClass('span3')
  if category == "Commission" || category == "Consignment"
    $('#date').show()
    $('#end_date').show()
    $('#work').show()
    if category == "Commission"
      $('#client').show()
    else
      $('#venue').show()
  else if category != "Please select"
    $('#date').show()
    $('#work').show()
    if category == "Sale"
      $('#venue').show()
      $('#client').show()
      $('#client').addClass('span3')
      $('#client').removeClass('span4')
    else if category == "Donate"
      $('#venue').show()
    else if category == "Gift"
      $('#client').show()
    else if category == "Recycle"
      $('#date').addClass('span4')
      $('#date').removeClass('span3')        