# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/             

# General functions

toggle_sidebar = () ->
  console.log("Side bar toggled.")
  $('#toggleSidebar').toggleClass('icon-chevron-left icon-chevron-right')
  $('#sidebar').toggleClass('span2 gone')
  $('#content').toggleClass('span10 span12')
  $('#content').toggleClass('offset2 offset0')
  $('#content').toggleClass('less-indent junk')
  $('#sidebar-content').toggleClass('show not-displayed')

hide_activity_form = () ->
  console.log("Running hide form. " + window.location.pathname + window.location.search)
  $('#venue').hide()
  $('#client').hide()
  $('#start_date').hide()
  $('#end_date').hide()
  $('#work').hide()

format_activity_form = () ->
  console.log("Formatting form for new selection")
  category = $('#activity_activitycategory_id :selected').text()
  $('#venue').hide()
  $('#client').hide()
  $('#start_date').hide()
  $('#end_date').hide()
  $('#work').hide()
  $('#start_date').removeClass('first-child')
  $('#client').removeClass('first-child')
  $('#start_date').removeClass('first-child')
  if category == "Commission" || category == "Consignment"
    $('#start_date_label').show()
    $('#date_label').hide()
    $('#start_date').show()
    $('#end_date_label').show()
    $('#payment_date_label').hide()
    $('#end_date').show()
    $('#work').show()
    if category == "Commission"
      $('#client').show()
      $('#client').addClass('first-child')
    else
      $('#venue').show()
  else if category != "Please select"
    $('#start_date_label').hide()
    $('#date_label').show()
    $('#start_date').show()
    $('#work').show()
    if category == "Sale"
      $('#venue').show()
      $('#client').show()
      $('#end_date_label').hide()
      $('#payment_date_label').show()
      $('#end_date').show()
    else if category == "Donate"
      $('#venue').show()
    else if category == "Gift"
      $('#client').show()
      $('#client').addClass('first-child')
    else if category == "Recycle"  
      $('#start_date').addClass('first-child')  

toggle_print = () ->
  if $('#content').attr("class").toString().match("span10") != null
    toggle_sidebar()
  window.print() 


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
  }
  console.log("Popover js has run"))   

$ ->
  $(".display_toggle").click ->
    element_id = $(@).attr("id").replace("_display", "")
    $('#' + element_id).slideToggle()

$ ->
  $(".document_print").click ->
    toggle_print()   


# Pages that lead to js
$ ->
  if (window.location.pathname.match(/activities\/new/))
    if (window.location.search.match(/\?category/))
      format_activity_form()
    else
      hide_activity_form()
  else if (window.location.pathname.match(/activities/))
    format_activity_form()

$ ->    
  $('#activity_activitycategory_id').change ->
    format_activity_form()  

# Events that lead to js
