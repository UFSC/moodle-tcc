$(function() {
    $("[data-behaviour~='datepicker']").datepicker({
        format: "dd/mm/yyyy",
        language: 'pt-BR',
        autoclose: true,
        todayHighlight: true
    });
});