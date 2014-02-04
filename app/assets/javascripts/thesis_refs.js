$(document).ready(function() {
    alert('ASDADASD');
    $('input[name="thesis_ref[type_thesis]"]').on('change', function() {
        alert($(this).val());
    });
});
