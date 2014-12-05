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
  $('#client').hide()
  $('#venue').hide()
  $('#start_date').hide()
  $('#end_date').hide()
  $('#work').hide()
  $('#activity_form_document').hide()
  $('#activity_form_works').hide()

format_activity_form = () ->
  console.log("Formatting form for new category: " + category)
  category = $('#activity_category_id :selected').text()
  $('#activity_form_works_legend').text('Works in ' + category )
  hide_activity_form()
  $('#start_date').removeClass('first-child')
  $('#client').removeClass('first-child')
  $('#activity_form_works').show()
  if category == "Show" || category == "Consignment"
    $('#start_date_label').text("Start Date *").show()
    console.log('category is show or consignment.')
    $('#start_date').show()
    $('#end_date_label').text("End Date").show()
    $('#end_date').show()
    $('#venue').show()      
  else if category != "Please select"
    $('#start_date_label').text("Date *").show()
    $('#start_date').show()
    if category == "Donation"
      $('#venue').show() 
    else if category == "Gift" || category == "Sale"
      $('#client').addClass('first-child')
      $('#client').show()
      if category == "Sale"
        $('#end_date_label').text("Paid Date").show()
        $('#end_date').show()  

toggle_print = () ->
  if $('#content').attr("class").toString().match("span10") != null
    toggle_sidebar()
  window.print() 

add_activitywork = (works_hash) ->
  #Grab basic information on rows
  new_line = $('#activityworks tbody>tr:last').clone(true)
  old_id = $('#activityworks tbody>tr:last>td:last>input').attr("id").toString().replace(/\D/g,'')
  new_id = (parseInt(old_id) + 1).toString()
    
  # Grab the index of the work so we can look it up in the hash and grab income, retail, and quantity
  work_id = $('#new_' + old_id + '_work_id option').filter(':selected').attr('value')
  console.log('a work was selected:' + work_id != 'Select a work')
  console.log('the work was:-' + work_id + '-')
  if work_id != 'Select a work'
    # Create new row
    re = new RegExp(old_id,"g")
    new_line.children('td').children('select').attr("id", 'new_' + new_id + '_work_id')
    new_line.children('td').children('select').attr("name", 'new[' + new_id + '][work_id]')
    new_line.children('td').each (index, td) =>
      e_id= $(td).children('input').attr("id")
      e_name = $(td).children('input').attr("name")
      if typeof e_id != "undefined" && e_id != null
        e_id = e_id.replace(re, new_id)
        e_name = e_name.replace(re, new_id)
        $(td).children('input').attr("id", e_id)
        $(td).children('input').attr("name", e_name)
        $(td).children('input').attr("value", "")
  
    # look up the new work added in the hash and grab income, retail, and quantity
    work_array = works_hash[work_id]

    # Alter last line of existing table to save data and remove add button
    $($('#activityworks tbody>tr:last').children('td')[0]).children('a').remove()
    $($('#activityworks tbody>tr:last').children('td')[2]).children('input').attr("value", work_array[0])
    $($('#activityworks tbody>tr:last').children('td')[3]).children('input').attr("value", work_array[1])
    $($('#activityworks tbody>tr:last').children('td')[4]).children('input').attr("value", "1")
    if $('#activityworks tbody>tr:last').children('td').length == 6
      $($('#activityworks tbody>tr:last').children('td')[5]).children('input').attr("value", work_array[2])
    else
      $($('#activityworks tbody>tr:last').children('td')[5]).children('input').attr("value", "0")
      $($('#activityworks tbody>tr:last').children('td')[6]).children('input').attr("value", work_array[2])

    # Insert new row as last in table
    new_line.insertAfter('#activityworks tbody>tr:last')


  # IDs that lead to js
$ ->
  $('#activity_add_activitywork').click ->
    works_string = $('#activity_add_activitywork').attr('data-url').toString()
    works_array = works_string.split ','
    works_hash = {}
    for s in works_array
      a = s.split('-')
      works_hash[a[0]] = [a[1],a[2],a[3]]
    add_activitywork(works_hash)

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
  $('#activity_category_id').change ->
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
