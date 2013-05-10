$(function() {
    $(".collapse").css("height", "100px");

    $(".accordion-toggle").click(function() {
        accordion(this);
        changeIcon(this);
    });
});


function accordion(element) {
    var collapse_id = $(element).attr("id")+"_collapse";
    var height = $("#"+collapse_id).height();

    if (height < 400) {
        $("#"+collapse_id).css("height", "400px");
    } else {
        $("#"+collapse_id).css("height", "100px");
    }
}

function changeIcon(element) {
    var icon =  $(element).closest(".accordion-group").find(".accordion-toggle-icon").find("i");
    var icon_class = icon.attr("class");
    if(icon_class == "icon-chevron-down") {
        icon.removeClass("icon-chevron-down").addClass("icon-chevron-up");
    } else {
        icon.removeClass("icon-chevron-up").addClass("icon-chevron-down");
    }
}