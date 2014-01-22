# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# IDs that lead to js
$ ->
  $('#toggleSidebar').click ->
    toggle_sidebar()


# Classes that lead to js

$ ->
  $(".datepicker").datepicker({
                dateFormat : "dd MM yy",
                #showOn : "both",
                changeMonth : true,
                changeYear : true,
                yearRange : "c-20:c+5"
            })

$ ->
  $(".tooltip").tooltip()    

$ ->
  $(".popover-input").popover({ 
    trigger: "hover" 
  })   

$ ->
  $(".display_toggle").click ->
    element_id = $(@).attr("id").replace("_display", "")
    $('#' + element_id).slideToggle()

$ ->
  $(".view_toggle").click ->
    $('#thumb_view_display').toggleClass('show not-displayed')
    $('#thumb_view').toggleClass('show not-displayed')
    $('#list_view_display').toggleClass('show not-displayed')
    $('#list_view').toggleClass('show not-displayed')  

$ ->
  $(".document_print").click ->
    toggle_print()


# Pages that lead to js
$ ->
  if (window.location.pathname.match(/activities\//))
    format_activity_form()
  else if (window.location.pathname.match(/activities/))
    console.log("In else if block for activities.")
    hide_activity_form()
  else if (window.location.pathname.match(/works\//))
    hide_activity_form()
  else if (window.location.pathname.match(/works/))
    console.log("In else if block for works.")
    toggle_sidebar()

$ ->
  if (window.location.pathname.match(/venues\//))
    hide_activity_form()

$ ->
  if (window.location.pathname.match(/clients\//))
    hide_activity_form() 

$ ->    
  $('#activity_activitycategory_id').change ->
    format_activity_form()              

# General functions 

toggle_sidebar = () ->
  $('#toggleSidebar').toggleClass('icon-chevron-left icon-chevron-right')
  $('#sidebar').toggleClass('span2 gone')
  $('#content').toggleClass('span10 span12')
  $('#content').toggleClass('offset2 offset0')
  $('#content').toggleClass('less-indent junk')
  $('#sidebar-content').toggleClass('show not-displayed')

hide_activity_form = () ->
  console.log("Running hide form. " + window.location.pathname)
  $('#venue').hide()
  $('#client').hide()
  $('#date').hide()
  $('#end_date').hide()
  $('#work').hide()
  $('#client').removeClass('span4')

format_activity_form = () ->
  console.log("Formatting form for new selection")
  category = $('#activity_activitycategory_id :selected').text()
  $('#venue').hide()
  $('#client').hide()
  $('#date').hide()
  $('#end_date').hide()
  $('#work').hide()
  $('#date').addClass('span3')
  $('#date').removeClass('span4')
  $('#date').removeClass('first-child')
  $('#client').removeClass('span4')
  $('#client').removeClass('span3')
  $('#client').removeClass('first-child')
  $('#date').removeClass('first-child')
  if category == "Commission" || category == "Consignment"
    $('#date').show()
    $('#end_date').show()
    $('#work').show()
    if category == "Commission"
      $('#client').show()
      $('#client').addClass('first-child span4')
    else
      $('#venue').show()
  else if category != "Please select"
    $('#date').show()
    $('#work').show()
    if category == "Sale"
      $('#venue').show()
      $('#client').show()
      $('#client').addClass('span3')
    else if category == "Donate"
      $('#venue').show()
    else if category == "Gift"
      $('#client').show()
      $('#client').addClass('first-child span4')
    else if category == "Recycle"
      $('#date').removeClass('span3')    
      $('#date').addClass('first-child span4')  

toggle_print = () ->
  if $('#content').attr("class").toString().match("span10") != null
    toggle_sidebar()
  window.print() 