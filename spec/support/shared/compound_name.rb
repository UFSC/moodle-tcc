shared_context 'an authorized user who can edit compound names' do |role|

  let(:attributes) { Fabricate.attributes_for(:compound_name) }

  before :each do
    page.set_rack_session(fake_lti_session(role))
    visit bibliographies_path
  end

  it 'page should has compound names tab' do
    expect(page).to have_content(I18n.t(:compound_name))
  end

  it 'create a new compound name' do
    click_link I18n.t(:compound_name)
    click_link I18n.t(:add_compound_name_or_suffix)

    fill_in 'Nome composto:', :with => attributes[:name], :exact => true

    click_button I18n.t(:save)

    expect(page).to have_content(attributes[:name])
  end

  it 'edit a compound name' do
    click_link I18n.t(:compound_name)
    click_link I18n.t(:add_compound_name_or_suffix)

    fill_in 'Nome composto:', :with => attributes[:name], :exact => true

    click_button I18n.t(:save)
    click_link I18n.t('activerecord.attributes.compound_name.edit')

    expect(page).to have_content(:success)
  end

  it 'remove a compound name' do
    name = attributes[:name]
    click_link I18n.t(:compound_name)
    click_link I18n.t(:add_compound_name_or_suffix)

    fill_in 'Nome composto:', :with => name, :exact => true

    click_button I18n.t(:save)
    click_button I18n.t('activerecord.attributes.compound_name.remove')

    expect(page).to have_content('Nome composto "' + name + '" removido.')
  end
end

shared_context 'an unauthorized user who cannot edit compound names' do |role|

  before :each do
    page.set_rack_session(fake_lti_session(role))
    visit bibliographies_path
  end

  it 'page should not has compound names tab' do
    expect(page).to_not have_content(I18n.t(:compound_name))
  end

end