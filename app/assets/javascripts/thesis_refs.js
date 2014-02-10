$(function() {
    $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', true);
    $('input[name="thesis_ref[type_thesis]"]').on('change', function() {
        switch ($(this).val()) {
            case 'Tese':
                $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', true);
                break;
            case 'Dissertação':
                $("#thesis_ref_degree option:contains(Mestrado)").attr('selected', true);
                break;
            case 'Monografia':
                $("#thesis_ref_degree option:contains(Especialização)").attr('selected', true);
                break;
            case 'TCC':
                $("#thesis_ref_degree option:contains(Graduação)").attr('selected', true);
                break;
            default:
                return false;
        }
    });
});