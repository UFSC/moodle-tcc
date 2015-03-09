module ChaptersHelper
  def diary_content content
    content.blank? ? t('empty_diaries') : content.html_safe
  end

  def with_citation_message(chapter)
    msg = ''
    b_cert = false
    if ((!chapter.tcc.nil?) &&
        (!chapter.tcc.tcc_definition.nil?) &&
        (chapter.tcc.count_references < chapter.tcc.tcc_definition.minimum_references)
    )
      msg += "Lembre-se que para a avaliação final e atribuição de nota do TCC deve haver ao menos #{chapter.tcc.tcc_definition.minimum_references} referências citadas no documento. </br></br>"
      b_cert = true
    end
    msg += done_message(b_cert)
    msg
  end

  def without_citation_message(chapter)
    msg = ''
    b_cert = false
    if (policy(chapter).must_verify_references?)
        msg += t(:warn_message_without_citation_html)
        b_cert = true
    end
    if ((!chapter.tcc.nil?) &&
        (!chapter.tcc.tcc_definition.nil?) &&
        (chapter.tcc.count_references < chapter.tcc.tcc_definition.minimum_references)
    )
      msg += "Lembre-se que para a avaliação final e atribuição de nota do TCC deve haver ao menos #{chapter.tcc.tcc_definition.minimum_references} referências citadas no documento. </br></br>"
      b_cert = true
    end
    msg += done_message(b_cert)
    msg
  end

  def done_message(certify)
    msg = ''
    msg += t(:warn_message_necessary_references_html)  if certify
    msg += t(:warn_message_sent_to_done_html)
    msg
  end
end

# Não foi encontrada qualquer citação de referência bibliográfica no texto do capítulo atual.
# Para a aprovação final e avaliação do TCC deve haver ao menos seis (6) referências citadas no documento.
# Certifique-se de que realmente não são necessárias referências nesse capítulo.
# Todo o texto contido nesta tela não poderá mais ser alterado após sua aprovação.
# Deseja continuar