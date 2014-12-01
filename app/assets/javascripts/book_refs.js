$(document).ready(function() {
    var authors = new Array();
    authors[0] = $("#book_ref_second_author");
    authors[1] = $("#book_ref_third_author");

    $("#book_ref_type_quantity").click(function() {
        $("#book_ref_num_quantity").attr('disabled', 'dislabled');
    });
    $("#book_ref_type_quantity_p").click(function() {
        $("#book_ref_num_quantity").removeAttr("disabled");
    });
    $("#book_ref_type_quantity_ed").click(function() {
        $("#book_ref_num_quantity").removeAttr("disabled");
    });

    $("#et_all").click(function() {
        var checked = $('#et_all').prop('checked');
        change_book_authors_state(checked, authors);
    });

    // Refazer estados dos campos

    var type_quatity_checked = $("input[name='book_ref[type_quantity]']:checked")
    if (type_quatity_checked && type_quatity_checked.val() != '') {
        $("#book_ref_num_quantity").removeAttr("disabled");
    }

    var et_all_checked = $("#et_all").prop('checked');
    change_book_authors_state(et_all_checked, authors);

});

function change_book_authors_state(checked, authors) {
    if (checked) {
        $.each(authors, function(index, author) {
            author.attr('disabled', 'dislabled');
        });
    }
    else {
        $.each(authors, function(index, author) {
            author.removeAttr("disabled");
        });
    }
}