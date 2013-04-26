$(function() {
    $(".collapse").collapse('show');

    $(".accordion-toggle").click(function() {
        accordion(this);
        changeIcon(this);
    });
});


function accordion(element) {
    var collapse_id = $(element).attr("id")+"_collapse";
    var height = $("#"+collapse_id).find(".accordion-inner").height();
    if (height < 400) {
        $("#"+collapse_id).find(".accordion-inner").css("height", "400px");
    } else {
        $("#"+collapse_id).find(".accordion-inner").css("height", "100px");
    }
    $("#"+collapse_id).collapse('show');
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