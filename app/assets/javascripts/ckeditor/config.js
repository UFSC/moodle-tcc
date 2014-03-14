CKEDITOR.editorConfig = function(config) {
    // Url para upload
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";
    //config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

    // Para resolver o problema do token perdido após o upload
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content'),
        moodle_user = $('meta[name=moodle-user]').attr('content');

    if (csrf_param !== undefined && csrf_token !== undefined) {
        config.filebrowserImageUploadUrl += "?" + csrf_param + "=" + encodeURIComponent(csrf_token)
    }
    // Para outros alem do aluno poderem enviar imagem
    if( moodle_user !== undefined )  config.filebrowserImageUploadUrl += '&moodle_user=' + moodle_user

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

    // Evitar problemas com html entities e linhas em branco
    config.basicEntities = false;
    config.entities_greek = false;
    config.entities_latin = false;
    config.entities_additional = false;
    config.fillEmptyBlocks = false;

    // Remover botoes que nao vao ser utilizados
    config.removeButtons = 'Flash,HorizontalRule,Smiley,SpecialChar,PageBreak,Iframe,CreateDiv,Styles,Font,FontSize';

    // Remover abas que nao devem aparecer
    config.removeDialogTabs = 'image:advanced;image:Link;table:advanced;tableProperties:advanced';

    config.toolbarGroups = [
        { name: 'styles' },
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'insert' },
        '/',
        { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
        { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ] },
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

CKEDITOR.on('dialogDefinition', function(event) {
    var dialogName = event.data.name;
    var dialogDefinition = event.data.definition;
    //some code here

    // janela de imagens: desabilita "URL, borda, espacamentos"
    // TODO: FIX-ME ta dando problema quando clica em "formatar imagem, ele não preenche a url quando a função abaixo é executada
//    if (dialogName == 'image') {
//        dialogDefinition.onShow = function() {
//            this.getContentElement("info", "txtBorder").disable();
//            this.getContentElement("info", "txtHSpace").disable();
//            this.getContentElement("info", "txtVSpace").disable();
//            this.getContentElement("info", "txtUrl").disable();
//        }
//    }

    // janela de tabelas: desabilita "borda, resumo, espacamentos"
//    if (dialogName == 'table' || dialogName == 'tableProperties') {
//        dialogDefinition.onShow = function() {
//            this.getContentElement("info", "txtBorder").disable();
//            this.getContentElement("info", "txtCellSpace").disable();
//            this.getContentElement("info", "txtCellPad").disable();
//            this.getContentElement("info", "txtSummary").disable();
//        }
//    }
});
