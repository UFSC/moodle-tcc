$(document).ready(function() {

    $("#article_ref_et_all").click(function() {
        var checked = $('#article_ref_et_all').prop('checked');
        change_article_authors_state(checked);
    });

    var et_all_checked = $("#article_ref_et_all").prop('checked');
    change_article_authors_state(et_all_checked);

});

function change_article_authors_state (checked){
    if (checked) {
        $("#article_ref_second_author").attr('disabled', 'dislabled');
        $("#article_ref_third_author").attr('disabled', 'dislabled');
    }
    else {
        $("#article_ref_second_author").removeAttr("disabled");
        $("#article_ref_third_author").removeAttr("disabled");
    }
}