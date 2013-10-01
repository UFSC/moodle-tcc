function compareTccObject() {
    $('#hub_portfolio_commentary').css('width', 425)
    $("#new_tcc_object").removeClass("span12").addClass("span6");
    $("#old_tcc_object").show();
    $("#compareTccObjectButtom").html("Ocultar comparação").attr("onclick", "hideOldTccObject()");
}

function hideOldTccObject() {
    $('#hub_portfolio_commentary').css('width', 905)
    $("#new_tcc_object").removeClass("span6").addClass("span12");
    $("#old_tcc_object").hide();
    $("#compareTccObjectButtom").html("Comparar versões").attr("onclick", "compareTccObject()");
}

function warnLeavingUnsaved() {
    changed = false;
    $("input[type='text']").change(function(){
        changed = true;
    });
    $('form').submit(function(){
        window.onbeforeunload = null;
        changed = false
    });
    window.onbeforeunload = function(e) {
        for (instance in CKEDITOR.instances) {
            var editor = CKEDITOR.instances[instance];
            if(editor.checkDirty()) {
                changed = true;
            }
        }
        if(changed) {
            return "Dados não salvos serão perdidos" ;
        }
    };
}

$(function(){
    $("#refresh-list").click(function() {
        location.reload();
    });

    // Notifica o usuário que ele não salvou antes de sair
    warnLeavingUnsaved();

});
$(function(){
    $('.tooltipped').tooltip();
});

