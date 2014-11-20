$(document).ready(function() {
    $('#degree').val($("#thesis_ref_degree").val());
});

$(function() {
    $('input[name="thesis_ref[type_thesis]"]').on('change', function() {
        $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', $(this).val() == 'Tese');
        $("#thesis_ref_degree option:contains(Mestrado)").attr('selected', $(this).val() == 'Dissertação');
        $("#thesis_ref_degree option:contains(Especialização)").attr('selected', $(this).val() == 'Monografia');
        $("#thesis_ref_degree option:contains(Graduação)").attr('selected', $(this).val() == 'TCC');
        $('#degree').val($("#thesis_ref_degree").val());
    });
});