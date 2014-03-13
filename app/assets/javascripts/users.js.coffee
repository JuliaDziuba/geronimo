# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $('#user_share_with_public').attr('checked')=="checked"
      show_public_form()

$ ->    
  $('#user_share_with_public').change ->
    # console.log('change in share with public')
    if $('#user_share_with_public').attr('checked')=="checked"
      show_public_form()
    else
      hide_public_form()

$ ->    
  $('#user_share_about').change ->
    # console.log('change in share about')
    if $('#user_share_about').attr('checked')=="checked"
      $('#about_content').removeClass('not-displayed')
    else
      $('#about_content').addClass('not-displayed')

$ ->    
  $('#user_share_contact').change ->
    # console.log('change in share contact')
    if $('#user_share_contact').attr('checked')=="checked"
      $('#contact_content').removeClass('not-displayed')
    else
      $('#contact_content').addClass('not-displayed') 

$ ->    
  $('#user_share_works').change ->
    # console.log('change in share works')
    if $('#user_share_works').attr('checked')=="checked"
      $('#works_content').removeClass('not-displayed')
    else
      $('#works_content').addClass('not-displayed')  

$ ->    
  $('#user_share_purchase').change ->
    # console.log('change in share purchase')
    if $('#user_share_purchase').attr('checked')=="checked"
      $('#purchase_content').removeClass('not-displayed')
    else
      $('#purchase_content').addClass('not-displayed')                         

show_public_form = () ->  
  $('#general_content').removeClass('not-displayed')
  $('#share_about').removeClass('not-displayed')
  $('#share_contact').removeClass('not-displayed')
  $('#share_works').removeClass('not-displayed')
  $('#share_purchase').removeClass('not-displayed')
  if $('#user_share_about').attr('checked')=="checked"
    $('#about_content').removeClass('not-displayed')
  if $('#user_share_contact').attr('checked')=="checked"
    $('#contact_content').removeClass('not-displayed')
  if $('#user_share_works').attr('checked')=="checked"
    $('#works_content').removeClass('not-displayed')
  if $('#user_share_purchase').attr('checked')=="checked"
    $('#purchase_content').removeClass('not-displayed')

hide_public_form = () ->
  $('#general_content').addClass('not-displayed')
  $('#share_about').addClass('not-displayed')
  $('#about_content').addClass('not-displayed')
  $('#share_contact').addClass('not-displayed')
  $('#contact_content').addClass('not-displayed') 
  $('#share_works').addClass('not-displayed')
  $('#works_content').addClass('not-displayed')
  $('#share_purchase').addClass('not-displayed')
  $('#purchase_content').addClass('not-displayed')


#! Copyright (c) 2011 Piotr Rochala (http://rocha.la)
# * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
# * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
# *
# * Version: 0.2.5
# * 
# 
(($) ->
  jQuery.fn.extend slimScroll: (o) ->
    ops = o
    
    #do it for every element that matches selector
    @each ->
      isOverPanel = undefined
      isOverBar = undefined
      isDragg = undefined
      queueHide = undefined
      barHeight = undefined
      divS = "<div></div>"
      minBarHeight = 30
      wheelStep = 30
      o = ops or {}
      cwidth = o.width or "auto"
      cheight = o.height or "250px"
      size = o.size or "7px"
      color = o.color or "#000"
      position = o.position or "right"
      opacity = o.opacity or .4
      alwaysVisible = o.alwaysVisible is true
      
      #used in event handlers and for better minification
      me = $(this)
      
      #wrap content
      wrapper = $(divS).css(
        position: "relative"
        overflow: "hidden"
        width: cwidth
        height: cheight
      ).attr(class: "slimScrollDiv")
      
      #update style for the div
      me.css
        overflow: "hidden"
        width: cwidth
        height: cheight

      
      #create scrollbar rail
      rail = $(divS).css(
        width: "15px"
        height: "100%"
        position: "absolute"
        top: 0
      )
      
      #create scrollbar
      bar = $(divS).attr(
        class: "slimScrollBar "
        style: "border-radius: " + size
      ).css(
        background: color
        width: size
        position: "absolute"
        top: 0
        opacity: opacity
        display: (if alwaysVisible then "block" else "none")
        BorderRadius: size
        MozBorderRadius: size
        WebkitBorderRadius: size
        zIndex: 99
      )
      
      #set position
      posCss = (if (position is "right") then right: "1px" else left: "1px")
      rail.css posCss
      bar.css posCss
      
      #wrap it
      me.wrap wrapper
      
      #append to parent div
      me.parent().append bar
      me.parent().append rail
      
      #make it draggable
      bar.draggable
        axis: "y"
        containment: "parent"
        start: ->
          isDragg = true

        stop: ->
          isDragg = false
          hideBar()

        drag: (e) ->
          
          #scroll content
          scrollContent 0, $(this).position().top, false

      
      #on rail over
      rail.hover (->
        showBar()
      ), ->
        hideBar()

      
      #on bar over
      bar.hover (->
        isOverBar = true
      ), ->
        isOverBar = false

      
      #show on parent mouseover
      me.hover (->
        isOverPanel = true
        showBar()
        hideBar()
      ), ->
        isOverPanel = false
        hideBar()

      _onWheel = (e) ->
        
        #use mouse wheel only when mouse is over
        return  unless isOverPanel
        e = e or window.event
        delta = 0
        delta = -e.wheelDelta / 120  if e.wheelDelta
        delta = e.detail / 3  if e.detail
        
        #scroll content
        scrollContent 0, delta, true
        
        #stop window scroll
        e.preventDefault()  if e.preventDefault
        e.returnValue = false

      scrollContent = (x, y, isWheel) ->
        delta = y
        if isWheel
          
          #move bar with mouse wheel
          delta = bar.position().top + y * wheelStep
          
          #move bar, make sure it doesnt go out
          delta = Math.max(delta, 0)
          maxTop = me.outerHeight() - bar.outerHeight()
          delta = Math.min(delta, maxTop)
          
          #scroll the scrollbar
          bar.css top: delta + "px"
        
        #calculate actual scroll amount
        percentScroll = parseInt(bar.position().top) / (me.outerHeight() - bar.outerHeight())
        delta = percentScroll * (me[0].scrollHeight - me.outerHeight())
        
        #scroll content
        me.scrollTop delta
        
        #ensure bar is visible
        showBar()

      attachWheel = ->
        if window.addEventListener
          @addEventListener "DOMMouseScroll", _onWheel, false
          @addEventListener "mousewheel", _onWheel, false
        else
          document.attachEvent "onmousewheel", _onWheel

      
      #attach scroll events
      attachWheel()
      getBarHeight = ->
        
        #calculate scrollbar height and make sure it is not too small
        barHeight = Math.max((me.outerHeight() / me[0].scrollHeight) * me.outerHeight(), minBarHeight)
        bar.css height: barHeight + "px"

      
      #set up initial height
      getBarHeight()
      showBar = ->
        
        #recalculate bar height
        getBarHeight()
        clearTimeout queueHide
        
        #show only when required
        return  if barHeight >= me.outerHeight()
        bar.fadeIn "fast"

      hideBar = ->
        
        #only hide when options allow it
        unless alwaysVisible
          queueHide = setTimeout(->
            bar.fadeOut "slow"  if not isOverBar and not isDragg
          , 1000)

    
    #maintain chainability
    this

  jQuery.fn.extend slimscroll: jQuery.fn.slimScroll
) jQuery

#invalid name call
$("#pw_thumbnails").slimscroll
  color: "#00f"
  size: "10px"
  width: "50px"
  height: "150px"
