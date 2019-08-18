$(function () {
  $("#group-view").on("click", function () {
    Cookies.set("active_practice_button", "groups");
    $("#group-view").addClass("active");
    $("#practice-list").addClass("hidden");
    $("#list-view").removeClass("active");
    return $("#practice-groups").removeClass("hidden");
  });
  return $("#list-view").on("click", function () {
    Cookies.set("active_practice_button", "list");
    $("#list-view").addClass("active");
    $("#practice-list").removeClass("hidden");
    $("#group-view").removeClass("active");
    return $("#practice-groups").addClass("hidden");
  });
});

