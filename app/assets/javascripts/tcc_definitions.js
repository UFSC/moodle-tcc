$(function() {
    $(".help-block").each(function() {
            $(this).hide();
            label = $(this).parent().siblings('label');
            label.attr("data-original-title", $(this).text());
            label.attr("data-placement", "bottom");
            tt_option = {delay: { "show": 750, "hide": 200 }};
            label.tooltip(tt_option);
        }
    );
});
