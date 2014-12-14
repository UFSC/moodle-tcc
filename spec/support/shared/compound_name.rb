shared_context 'an authorized user who can edit compound names' do |role|

  let(:compound_name_attrs) { Fabricate.attributes_for(:compound_name) }
  let(:compound_name) { Fabricate(:compound_name) }

  before :each do
    page.set_rack_session(fake_lti_session(role))
  end

  it 'page should has compound names tab' do
    visit bibliographies_path(anchor: 'compound_names')
    expect(page).to have_content(I18n.t(:compound_name))
  end

  it 'create a new compound name', js: true do
    visit bibliographies_path(anchor: 'compound_names')
    click_link I18n.t(:add_compound_name_or_suffix)

    expect(page).to have_content('Adição de nome composto') # wait for ajax
    fill_in 'Nome composto:', :with => compound_name_attrs[:name], :exact => true

    click_button I18n.t(:save)

    expect(page).to have_content(compound_name_attrs[:name])
  end

  it 'edit a compound name', js: true do
    compound_name # cria o nome composto
    visit bibliographies_path(anchor: 'compound_names')

    click_link I18n.t(:compound_name)
    expect(page).to have_content(compound_name.name)

    click_link I18n.t('activerecord.attributes.compound_name.edit')

    expect(page).to have_content('Edição de nome composto') # wait for ajax
    fill_in 'Nome composto:', :with => compound_name_attrs[:name], :exact => true

    click_button I18n.t(:save)
    expect(page).to have_content(:success)
  end

  it 'remove a compound name', js: true do
    compound_name # cria o nome composto
    visit bibliographies_path(anchor: 'compound_names')

    click_link I18n.t(:compound_name)
    click_button I18n.t('activerecord.attributes.compound_name.remove')

    expect(page).to have_content('Tem certeza que deseja apagar o nome composto') # wait for ajax

    click_link 'Sim'

    expect(page).to have_content('Nome composto "' + compound_name[:name] + '" removido.')
  end
end

shared_context 'an unauthorized user who cannot edit compound names' do |role|

  before :each do
    page.set_rack_session(fake_lti_session(role))
    visit bibliographies_path(anchor: 'compound_names')
  end

  it 'page should not has compound names tab' do
    expect(page).to_not have_content(I18n.t(:compound_name))
  end

end