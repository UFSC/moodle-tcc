$(function() {
    $('input[name="thesis_ref[type_thesis]"]').on('change', function() {

        switch ($(this).val()) {
            case 'Tese':
                $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', true);
                $("#thesis_ref_degree option:contains(Mestrado)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Especialização)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Graduação)").attr('selected', false);
                $('#degree').val('Doutorado');
                break;
            case 'Dissertação':
                $("#thesis_ref_degree option:contains(Mestrado)").attr('selected', true);
                $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Especialização)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Graduação)").attr('selected', false);
                $('#degree').val('Mestrado');
                break;
            case 'Monografia':
                $("#thesis_ref_degree option:contains(Especialização)").attr('selected', true);
                $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Mestrado)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Graduação)").attr('selected', false);
                $('#degree').val('Especialização');
                break;
            case 'TCC':
                $("#thesis_ref_degree option:contains(Graduação)").attr('selected', true);
                $("#thesis_ref_degree option:contains(Doutorado)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Mestrado)").attr('selected', false);
                $("#thesis_ref_degree option:contains(Especialização)").attr('selected', false);
                $('#degree').val('Graduação');
                break;
            default:
                return false;
        }
    });
});