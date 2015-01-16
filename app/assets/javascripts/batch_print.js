/**
 * Created by rsc on 16/01/15.
 */
$(function() {
    $('input[name="must_print"]').on('change', function() {
//        alert('updated!')
        $.post('/listings/update', { param1: '1', param2: '2'}, function(data) {
            alert('updated!');
        });
    });
})

$('input[name="must_print2"]').bind('update', function() {
    $.post('/listings/update', { param1: '1', param2: '2'}, function(data) {
        alert('updated!');
    });
});
