$(function() {
    function def_tooltip(tool) {

        label = tool.parents().siblings('label');

        label.attr("data-original-title", tool.attr("tooltip"));
        label.attr("data-placement", "bottom");

        tt_option = {delay: { "show": 750, "hide": 200 }};
        label.tooltip(tt_option);
    }

    $("input").each(function() {
        def_tooltip($(this))
    });

    $("select").each(function() {
        def_tooltip($(this));
    });
});
$(document).ready(function(){
    $('.loading').click(function() {
        $('.fa-spinner').show();
    });
});