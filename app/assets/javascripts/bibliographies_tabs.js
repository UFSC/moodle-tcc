$(document).ready(function () {

    $("ul#tabs li").removeClass("active"); //Remove any "active" class
    $('.tab-content').addClass('hidden'); //Hide all tab content

    var tabs = $("ul#tabs li");
    var hash = window.location.hash;
    var component = tabs.find('[href=' + hash + ']').parent();

    component.addClass('active');
    $('#content-' + component.attr('id')).removeClass('hidden');
    tabs.click(function () {
        $('#tabs').find('li').each(function () {
            if ($(this).hasClass('active')) {
                $(this).removeClass('active');
                $('#content-' + $(this).attr('id')).addClass('hidden');
                return;
            }
        });
        $(this).addClass('active');
        $('#content-' + $(this).attr('id')).removeClass('hidden');
    });
});