$(document).ready(function() {
    if($('#refresh-list').length){
        window.onfocus = function() {
            location.reload();
        };
    }
});

