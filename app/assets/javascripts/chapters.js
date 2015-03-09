$(function() {
    $('input[type=submit][name="done"]').click(function() {
        //var tcc_count = parseInt($('#tcc_count_refs').val());
        var text = '';
        for (instance in CKEDITOR.instances){
            text = CKEDITOR.instances[instance].getData();
        }
        var chapter_count = text.split("</citacao>").length-1;
        var confirm_msg = (chapter_count > 0 ) ? 'with-citation' : 'without-citation';
        $('input[type=submit][name="done"]').data('confirm', $('input[type=submit][name="done"]').data(confirm_msg))
    });
});