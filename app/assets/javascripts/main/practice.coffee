$ ->
  $("#group-view").on "click", ->
    Cookies.set("active_practice_button", "groups")
    $("#group-view").addClass("active")
    $("#practice-list").addClass("hidden")
    $("#list-view").removeClass("active")
    $("#practice-groups").removeClass("hidden")

  $("#list-view").on "click", ->
    Cookies.set("active_practice_button", "list")
    $("#list-view").addClass("active")
    $("#practice-list").removeClass("hidden")
    $("#group-view").removeClass("active")
    $("#practice-groups").addClass("hidden")
