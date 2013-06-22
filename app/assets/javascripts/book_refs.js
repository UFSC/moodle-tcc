$(document).ready(function () {
    $("#book_ref_type_quantity").click(function () {
        $("#book_ref_num_quantity").attr('disabled', 'dislabled');
    });
    $("#book_ref_type_quantity_p").click(function () {
        $("#book_ref_num_quantity").removeAttr("disabled");
    });
    $("#book_ref_type_quantity_ed").click(function () {
        $("#book_ref_num_quantity").removeAttr("disabled");
    });
    var text = $("#book_ref_num_quantity");
    if (text.val() != '') {
        $("#book_ref_num_quantity").removeAttr("disabled");
    }
});
$(document).ready(function () {
    $("#et_all").click(function () {
        $("#book_ref_second_author").removeAttr("disabled");
        $("#book_ref_third_author").removeAttr("disabled");
    });
});