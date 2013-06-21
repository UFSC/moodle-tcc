CKEDITOR.editorConfig = function( config ) {
    config.toolbarGroups = [
        { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
        { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'styles' },
        { name: 'tools' },
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
