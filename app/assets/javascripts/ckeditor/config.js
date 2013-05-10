CKEDITOR.editorConfig = function( config ) {
    config.toolbarGroups = [
        { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
        { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
        { name: 'insert' },
        { name: 'document',    groups: [ 'mode', 'document', 'doctools' ] },
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'styles' },
        { name: 'colors' },
        { name: 'tools' },
    ]
    config.extraPlugins = 'citacao'
    config.allowedContent = true
};
