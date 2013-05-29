function compareHubs() {
    $("#new_hub").removeClass("span12").addClass("span6");
    $("#old_hub").show();
    $("#compareHubsButtom").html("Ocultar comparação").attr("onclick", "hideOldHub()");
}

function hideOldHub() {
    $("#new_hub").removeClass("span6").addClass("span12");
    $("#old_hub").hide();
    $("#compareHubsButtom").html("Comparar versões").attr("onclick", "compareHubs()");
}