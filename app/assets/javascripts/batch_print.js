/**
 * Created by rsc on 16/01/15.
 */

function addMoodle_id(originString, moodle_id) {

    var arr = (originString.trim() == "") ? [] : originString.split(";");
    var pos = arr.indexOf(moodle_id);
    if (pos < 0) {
        arr.push(moodle_id);
    }
    return (arr.length >= 2) ? arr.join(";") : arr.toString();
}

function removeMoodle_id(originString, moodle_id) {
    var aux_str = originString;
    var arr = originString.split(";");
    var pos = arr.indexOf(moodle_id);
    if (pos >= 0) {
        aux_str = aux_str.replace(moodle_id, "");
        if (aux_str.indexOf(";") == 0) {
            aux_str = aux_str.substr(1, aux_str.length-1)
        } else if ((aux_str.lastIndexOf(";") == (aux_str.length-1))) {
            aux_str = aux_str.substr(0, aux_str.length-1)
        } else {
            aux_str = aux_str.replace(";;", ";");
        }
        arr = (aux_str.trim() == "") ? [] : aux_str.split(";");
    }
    return (arr.length >= 2) ? arr.join(";") : arr.toString();
}


$(function() {
    $('#bt_todos').click(function () {
        $("INPUT[type='checkbox']").each(function(){
            this.checked = true;
        }).trigger( 'change' );
    });

    $('#bt_nenhum').click(function () {
        $("INPUT[type='checkbox']").each(function(){
            this.checked = false;
        }).trigger( 'change' );
    });

    $('#bt_inverter').click(function () {
        $("INPUT[type='checkbox']").each(function(){
            this.checked = !this.checked;
        }).trigger( 'change' );
    });

    $('#bt_comNota').click(function () {
        $("INPUT[type='checkbox']").each(function(){
            this.checked = $(this).attr('class') == 'grade'
        }).trigger( 'change' );
    });

    $('#bt_imprimir').click(function () {
        //if ($('input[name="moodle_ids"]').val() == '') {
        //    alert('Ao menos um tcc deve ser selecionado para impressão');
        //    return false;
        //}
    });

    $('input[name="must_print"]').on('change', function() {
        var str_ids = $('input[name="moodle_ids"]').val();
        var str_id = $(this).val();
        var str_new_ids = "";
        if ($(this).is(':checked')) {
            str_new_ids = addMoodle_id(str_ids, str_id)
        } else {
            str_new_ids = removeMoodle_id(str_ids, str_id)
        }
        $('input[name="moodle_ids"]').val(str_new_ids);
    });
});
