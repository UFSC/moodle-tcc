$(function() {
    $("[type~='date']").datepicker({
        format: "dd/mm/yyyy",
        language: 'pt-BR',
        autoclose: true,
        todayHighlight: true
    });
});