$(document).bind "mobileinit", ->
  $.mobile.ajaxEnabled = false

$ ->
  $("input[name='race_team[riders][]']").change ->
    $("#nr_of_selected_riders").html $("input[name='race_team[riders][]']:checked").length
  
  $("#stages").change ->
    $("#stages_form").attr("action",$("#stages").val())
    $("#stages_form").submit()
