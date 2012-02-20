# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $(".result_rider").autocomplete
    source: (request, response) ->
      $.ajax
        type: "post"
        dataType: "json"
        data:
          term: request.term
  
        url: "/riders/result_search"
        success: (data) ->
          response $.map(data, (item) ->
            label: item.name
            value: item.id
          )

    minLength: 2
    focus: (event, ui) ->
      $(this).val ui.item.label
      false
  
    select: (event, ui) ->
      $(this).val ui.item.label
      $("#" + $(this).attr("id") + "_id").val ui.item.value
      $(this).parents(".clearfix").first().addClass "success"
      false