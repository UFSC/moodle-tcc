$(function() {
    //Date picker
    $("[data-behaviour~='datepicker']").datepicker({
        format: "dd/mm/yyyy",
        language: 'pt',
        autoclose: true
    });

    // Tabs
    $(function() {
        $('li').click(function() {
            var id_new_tab = $(this).attr("id");
            var id_old_tab = $("li.active").attr("id");

            $("#"+id_old_tab+"_content").hide();
            $("#"+id_new_tab+"_content").show();
            $("li.active").removeClass("active");
            $(this).addClass("active");
        });
    });
});