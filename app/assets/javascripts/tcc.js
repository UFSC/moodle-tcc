function compareTccObject() {
    $("#new_tcc_object").removeClass("span12").addClass("span6");
    $("#old_tcc_object").show();
    $("#compareTccObjectButtom").html("Ocultar comparação").attr("onclick", "hideOldTccObject()");
}

function hideOldTccObject() {
    $("#new_tcc_object").removeClass("span6").addClass("span12");
    $("#old_tcc_object").hide();
    $("#compareTccObjectButtom").html("Comparar versões").attr("onclick", "compareTccObject()");
}

$(function(){
    $("#refresh-list").click(function() {
        location.reload();
    });
});
