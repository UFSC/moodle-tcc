CKEDITOR.dialog.add('citacaoDialog', function (editor) {

    var items = [];
    $.ajax({
        dataType: "json",
        url: 'bibliographies.json',
        async: false,
        success: function (data) {
            $.each(data, function (key, val) {
                items.push([val.reference_text, val.id, val.direct_citation, val.indirect_citation, val.reference_text]);
            });
        }
    });
    return {
        title: 'Adicionar Citação',
        minWidth: 400,
        minHeight: 200,

        contents: [
            {
                id: 'tab-general-ref',
                label: 'Referência Geral',
                elements: [
                    {
                        type: 'select',
                        id: 'ref-list',
                        style: 'width: 400px',
                        label: 'Escolha a citação',
                        items: items

                    },
                    {
                        type: 'fieldset',
                        id: 'fieldset-cit',
                        label: 'Tipo de Citação',
                        align: 'left',
                        style: 'margin-top: 50px',
                        children: [
                            {
                                type: 'radio',
                                id: 'ref-cit',
                                items: [
                                    [ 'Citação Direta', 'cd' ],
                                    [ 'Citação Indireta', 'ci' ]
                                ],
                                'default': 'cd'
                            }
                        ]
                    }
//                    ,
//                    {
//                        type: 'html',
//                        id: 'new-citacao',
//                        label: 'Criar Nova Citação',
//                        html: "<a href='/general_refs/new'>Criar Nova Referência</a>"
//                    }

                ]
            }
        ],
        onOk: function() {
            var id_citacao = this.getValueOf('tab-general-ref', 'ref-list');
            var tipo_citacao = this.getValueOf('tab-general-ref', 'ref-cit');

            CKEDITOR.plugins.citacao.createPlaceholder(editor, this,id_citacao , tipo_citacao);
        }

    };


});