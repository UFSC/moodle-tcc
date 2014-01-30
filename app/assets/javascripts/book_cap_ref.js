$(document).ready(function() {
    var authors_entire = new Array();
    authors_entire[0] = $("#book_cap_ref_second_entire_author");
    authors_entire[1] = $("#book_cap_ref_third_entire_author");

    var authors_part = new Array();

    authors_part[0] = $("#book_cap_ref_second_part_author");
    authors_part[1] = $("#book_cap_ref_third_part_author");

    $("#et_al_entire").click(function() {
        var checked = $('#et_al_entire').prop('checked');

        change_book_authors_state(checked, authors_entire);
    });
    $("#et_al_part").click(function() {
        var checked = $('#et_al_part').prop('checked');

        change_book_authors_state(checked, authors_part);
    });

    // Refazer estados dos campos
    var et_all_checked = $("#et_al_entire").prop('checked');
    change_book_authors_state(et_all_checked, authors_entire);

    var et_all_checked = $("#et_al_part").prop('checked');
    change_book_authors_state(et_all_checked, authors_part);

});

function change_book_authors_state(checked, authors) {
    if (checked) {
        for (i = 0, max = authors.length; i < max; i++) {
            authors[i].attr('disabled', 'dislabled');
        }
    }
    else {
        for (i = 0, max = authors.length; i < max; i++) {
            authors[i].removeAttr("disabled");
        }
    }
}