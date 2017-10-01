shared_context 'an authorized user who can edit compound names' do |role|

  let(:compound_name_attrs) { Fabricate.attributes_for(:compound_name) }
  let(:compound_name) { Fabricate(:compound_name) }

  before :each do
    page.set_rack_session(fake_lti_session(role))
  end

  it 'page should has compound names tab' do
    visit compound_names_path(anchor: 'compound_names')
    expect(page).to have_content(I18n.t('activerecord.models.compund_name'))
  end

  # ToDo: Repor o teste de compound name, depende de modal
  xit 'create a new compound name', js: true do
    visit compound_names_path(anchor: 'compound_names')
    xhr :get, new_compound_name_path, format: :js
    # click_link I18n.t(:add_compound_name_or_suffix)

    expect(page).to have_content('Adição de nome composto') # wait for ajax
    fill_in 'compound_name[name]', :with => compound_name_attrs[:name], :exact => true

    click_button I18n.t(:save)

    expect(page).to have_content(compound_name_attrs[:name])
  end

  # ToDo: Repor o teste de compound name, depende de modal
  xit 'edit a compound name', js: true do
    compound_name # cria o nome composto
    visit compound_names_path(anchor: 'compound_names')

    expect(page).to have_content(compound_name.name)

    click_link I18n.t('edit')

    expect(page).to have_content('Edição de nome composto') # wait for ajax
    fill_in 'compound_name[name]', :with => compound_name_attrs[:name], :exact => true


    click_button I18n.t(:save)
    expect(page).to have_content(:success)
  end

  # ToDo: Repor o teste de compound name, depende de modal
  xit 'remove a compound name', js: true do
    compound_name # cria o nome composto
    visit compound_names_path(anchor: 'compound_names')

    click_button I18n.t('remove')

    expect(page).to have_content('Tem certeza que deseja apagar o nome composto') # wait for ajax

    click_link 'Sim'

    expect(page).to have_content('Nome composto "' + compound_name[:name] + '" removido.')
  end
end

shared_context 'an unauthorized user who cannot edit compound names' do |role|

  before :each do
    page.set_rack_session(fake_lti_session(role))
    visit compound_names_path(anchor: 'compound_names')
  end

  it 'page should not has compound names tab' do
    expect(page).to_not have_content(I18n.t('activerecord.models.compund_name'))
  end

end