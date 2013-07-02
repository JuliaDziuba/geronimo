# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_work_select').click ->
    console.log("new work has been selected")
    $('#new_work').slideToggle()

$ ->
  $('#edit_work_select').click ->
    $('#work_data').slideToggle()
    $('#edit_work').slideToggle()    

$ ->
  $('#update_image_select').click ->
    $('#update_image').slideToggle()   