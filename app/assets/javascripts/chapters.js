$(function() {
    $('input[type=submit][name="done"]').click(function() {
        var text = '';
        for (instance in CKEDITOR.instances){
            text = CKEDITOR.instances[instance].getData();
        }
        var count = text.split("</citacao>").length-1;
        var confirm_msg = (count > 0 ) ? 'done' : 'citation';
        $('input[type=submit][name="done"]').data('confirm', $('input[type=submit][name="done"]').data(confirm_msg))
    });
}) ;