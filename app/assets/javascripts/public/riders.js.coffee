# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  ajaxManager = $.manageAjax.create('ajaxManager', { queue: 'clear', abortOld: true })

  find_selected_riders = () ->
   riders = []
   $(".selected_rider").each -> riders.push(Number($(this).val()))
   return riders

  search_rider = (loading) ->
   val = $("#search_name").val()
   min = Number($("#search_min").val())
   max = Number($("#search_max").val())
   team = Number($("#cycling_team").val())
   if (loading == true)
    $("#search_name").addClass('ui-autocomplete-loading')
   params = {}
   if(val != null && val != "" && val.length != 0)
    params.name = val
   if(min != null && !isNaN(min) && min > 0)
    params.min = min
   if(max != null && !isNaN(max) && max > 0)
    params.max = max
   if(team != null && !isNaN(team) && team > 0)
    params.team = team
   params.riders = find_selected_riders()
   ajaxManager.add({type: 'post',data: params,success: null,url: '/riders/search'})

  update_chosen = () ->
   team_id = $("#race_team_team_id").val()
   riders = find_selected_riders()
   $.post('/race_teams/update_chosen',{team_id:team_id,riders: riders},null)

  get_rider_from_id = (str) -> return Number(str.replace("rider_",""))

  add_remove_rider = (event,el,add_or_remove) ->
   event.preventDefault()
   rider_id = get_rider_from_id(el.attr("id"))
   riders = find_selected_riders()
   if(add_or_remove == "add")
    $(el).remove()
   $("#selected_riders table").addClass("overlay")
   $("#selected_riders .loading").show()
   if(el.hasClass("team"))
    $.post('/teams/'+add_or_remove+'_rider', {rider_id: rider_id, riders: riders}, search_rider)
   else if(el.hasClass("race_team"))
    $.post('/race_teams/'+add_or_remove+'_rider', {rider_id: rider_id, riders: riders}, update_chosen)

  style_team_budget = (el) ->
   if(Number(el.val()) < 0)
    el.parents(".clearfix").first().addClass("error")
   else
    el.parents(".clearfix").first().removeClass("error")
  $(".remove_rider").live 'click', (event) -> add_remove_rider(event, $(this), 'remove')
  $(".add_rider").live 'click', (event) -> add_remove_rider(event, $(this), 'add')
  $("#search_name, #search_max, #search_min").keyup -> search_rider(true)
  $("#cycling_team").change => search_rider(true)
  $("#team_budget").change -> style_team_budget($(this))
  $("#team_budget").trigger 'change'
