# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  ajaxManager = $.manageAjax.create('ajaxManager', { queue: 'clear', abortOld: true })

  find_selected_riders = () ->
   riders = []
   $(".selected_rider").each -> riders.push(Number($(this).val()))
   return riders

  search_rider = () ->
   val = $("#search_name").val()
   $("#search_name").addClass('ui-autocomplete-loading')
   params = {}
   if(val != null && val != "" && val.length != 0)
    params.name = val
   params.riders = find_selected_riders()
   ajaxManager.add({type: 'post',data: params,success: null,url: '/riders/search'})

  get_rider_from_id = (str) -> return Number(str.replace("rider_",""))

  add_remove_rider = (event,el,add_or_remove) ->
   event.preventDefault()
   rider_id = get_rider_from_id(el.attr("id"))
   riders = find_selected_riders()
   $.post('/teams/'+add_or_remove+'_rider', {rider_id: rider_id, riders: riders}, search_rider)

  style_team_budget = (el) ->
   if(Number(el.val()) < 0)
    el.parents(".clearfix").first().addClass("error")
   else
    el.parents(".clearfix").first().removeClass("error")
  $(".remove_rider").live 'click', (event) -> add_remove_rider(event, $(this), 'remove')
  $(".add_rider").live 'click', (event) -> add_remove_rider(event, $(this), 'add')
  $("#search_name").keyup -> search_rider()
  $("#team_budget").change -> style_team_budget($(this))
  $("#team_budget").trigger 'change'
