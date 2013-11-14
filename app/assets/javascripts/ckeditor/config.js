CKEDITOR.editorConfig = function(config) {
    // Url para upload
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";

    // Para resolver o problema do token perdido após o upload
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content');

    if (csrf_param !== undefined && csrf_token !== undefined) {
        config.filebrowserImageUploadUrl += "?" + csrf_param + "=" + encodeURIComponent(csrf_token)
    }

    // Plugin de Citacao
    config.extraPlugins = 'citacao';
    config.allowedContent = true;

    // Configuracao de auto-resize
    config.autoGrow_maxHeight = 600;


    // Configuracao do Colar do Word
    config.pasteFromWordNumberedHeadingToList = true;
    config.pasteFromWordPromptCleanup = true;
    config.pasteFromWordRemoveFontStyles = true;
    config.pasteFromWordRemoveStyles = true;

    // Remover botoes que nao vao ser utilizados
    config.removeButtons = 'Flash,HorizontalRule,Smiley,SpecialChar,PageBreak,Iframe,CreateDiv,Styles,Font,FontSize';

    config.toolbarGroups = [
        { name: 'styles' },
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'insert' },
        '/',
        { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
        { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
        { name: 'tools' },
    ];

    config.toolbar_mini = [
        ['Bold', 'Italic', 'Underline', 'Subscript', 'Superscript', '-', 'RemoveFormat'],
        ['Maximize']
    ];

    config.toolbar_readonly = [
        ['Find', 'Maximize']
    ];

    config.language = 'pt-br';
};
