$(function() {
    if($(".collapse").hasClass("admin_view")) {
        var minHeight = 0
    } else {
        var minHeight = 100
    }
    var maxHeight = 400

    $(".collapse").css("height", minHeight+"px");

    $(".accordion-toggle").click(function() {
        accordion(this, minHeight, maxHeight);
        changeIcon(this);
    });
});


function accordion(element, minHeight, maxHeight) {
    var collapse_id = $(element).attr("id")+"_collapse";
    var height = $("#"+collapse_id).height();

    if (height < maxHeight) {
        $("#"+collapse_id).css("height", maxHeight+"px");
    } else {
        $("#"+collapse_id).css("height", minHeight+"px");
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