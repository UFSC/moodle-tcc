CKEDITOR.editorConfig = function( config ) {
    // Url para upload
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";

    // Para resolver o problema do token perdido após o upload
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content');

    if (csrf_param !== undefined && csrf_token !== undefined) {
        config.filebrowserImageUploadUrl += "?" + csrf_param + "=" + encodeURIComponent(csrf_token)
    }

    // Todo: cogitar outra maneira que nao envolvar remover botoes desnecessarios do insert
    config.removeButtons = 'Flash,HorizontalRule,Smiley,SpecialChar,PageBreak,Iframe';

    config.toolbarGroups = [
        { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
        { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'styles' },
        { name: 'tools' },
        { name: 'insert' },
    ];

    config.extraPlugins = 'citacao';
    config.allowedContent = true;

    config.toolbar_mini = [
        ['Bold', 'Italic', 'Underline', 'Subscript', 'Superscript', '-', 'RemoveFormat'],
        ['Maximize']
    ];

    config.toolbar_readonly = [
        ['Find', 'Maximize']
    ];

    config.language = 'pt-br';
};
