# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/             

# General functions

format_note_form = () ->
  console.log("Formatting note form.")
  $('#note_form_works').hide()
  $('#note_form_venues').hide()
  $('#note_form_clients').hide()
  type = $('#note_notable_type :selected').text()
  if type == "Work"
    $('#note_form_works').show()
  else if type == "Venue"
    $('#note_form_venues').show()
  else if type == "Client"
    $('#note_form_clients').show()

format_action_form = () ->
  console.log("Formatting action form.")
  $('#action_form_works').hide()
  $('#action_form_venues').hide()
  $('#action_form_clients').hide()
  type = $('#action_item_actionable_type :selected').text()
  if type == "Work"
    $('#action_form_works').show()
  else if type == "Venue"
    $('#action_form_venues').show()
  else if type == "Client"
    $('#action_form_clients').show()

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

# Action related js
$ ->
  if (window.location.pathname.match(/actions\/new/))
    format_action_form()   
  
$ ->
  $('#action_item_actionable_type').change ->
    format_action_form()    

# Note related js
$ ->
  if (window.location.pathname.match(/notes\/new/))
    format_note_form()   
  
$ ->
  $('#note_notable_type').change ->
    format_note_form()

# Events that lead to js
