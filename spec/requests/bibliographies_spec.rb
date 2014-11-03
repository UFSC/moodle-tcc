require 'spec_helper'

describe 'Bibliographies' do

  before :each do
    page.set_rack_session(fake_lti_session)
    visit bibliographies_path
  end

  it 'Livros' do
    click_link 'Livros'
    expect(page).to have_content('Livros')
  end

  it 'Capítulos de Livros' do
    click_link 'Capítulos de Livros'
    expect(page).to have_content('Capítulos de Livros')
  end

  it 'Artigos' do
    click_link 'Artigos'
    expect(page).to have_content('Artigos')
  end

  it 'Internet' do
    click_link 'Internet'
    expect(page).to have_content('Internet')
  end

  it 'Legislativo' do
    click_link 'Legislativo'
    expect(page).to have_content('Legislativo')
  end

  it 'Teses e Monografias' do
    click_link 'Teses e Monografias'
    expect(page).to have_content('Teses e Monografias')
  end

  xit 'Nomes Compostos' do
    click_link 'Nomes Compostos'
    expect(page).to have_content('Nomes compostos')
  end
end