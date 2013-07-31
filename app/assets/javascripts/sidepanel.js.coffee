


$ ->
  $('#toggleSidebar').click ->
    $('#toggleSidebar').toggleClass('icon-chevron-left icon-chevron-right')
    $('#sidebar').toggleClass('span2 gone')
    $('#content').toggleClass('span10 span12')
    $('#content').toggleClass('offset2 offset0')
    $('#content').toggleClass('less-indent junk')
    $('#sidebar-content').toggleClass('show not-displayed')
      