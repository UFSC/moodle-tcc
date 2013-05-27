$(document).ready(function () {
    $(".bibliographie-tab").click(function () {
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

