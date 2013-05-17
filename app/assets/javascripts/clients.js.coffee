# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#edit_client_select').click ->
    $('#client_data').slideToggle()
    $('#edit_client').slideToggle()

$ ->
  $('#new_client_select').click ->
    $('#new_client').slideToggle()    