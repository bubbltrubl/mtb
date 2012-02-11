$ ->
  $(".tabs").tabs()
$ ->
  $("a[rel=twipsy]").twipsy live: true
$ ->
  $("a[rel=popover], .popover-label").popover offset: 10
$ ->
  $(".topbar-wrapper").dropdown()
$ ->
  $(".alert-message, #error_explanation").alert()
$ ->
  domModal = $(".modal").modal(
    backdrop: true
    closeOnEscape: true
  )
  $(".open-modal").click ->
    domModal.toggle()  
