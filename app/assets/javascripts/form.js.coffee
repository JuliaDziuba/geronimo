# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

    


