CKEDITOR.editorConfig = function( config ) {
    // Url para upload
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";

    // Todo: cogitar outra maneira que não envolvar remover botões desnecessários do insert
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
