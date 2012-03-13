# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  use_this = (event,el) ->
   event.preventDefault()
   auth_id = Number(el.attr("data-id"))
   if(auth_id != null && !isNaN(auth_id))
    $.post('/authentications/use_this', {auth_id: auth_id})

  $(".use_this").live 'click', (event) -> use_this(event,$(this))
