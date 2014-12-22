$(document).ready(function() {
    if($('#refresh-list').length){
        //$('#search').val($('#search').val()+' refresh');
        $('#tcc-focus').val('true');
        window.onfocus = function() {
            // essa condicional foi colocada por causa do Windows (SO)
            // Entra duas vezes no focus antes do blur quando pressiona dropdown
            if ($('#tcc-focus').val() != 'true') {
                $('#tcc-focus').val('true');
                //$('#search').val($('#search').val()+' refresh-focus');
                location.reload();
            }
        };
        window.onblur = function() {
            //$('#search').val($('#search').val()+' refresh-blur');
            $('#tcc-focus').val('false');

        };
    }
});

