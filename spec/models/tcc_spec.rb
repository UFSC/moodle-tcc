# encoding: utf-8
require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate.build(:tcc) }

  it { should respond_to(:defense_date, :orientador, :student, :title, :tutor) }

  it { should have_many(:references) }
  it { should have_many(:book_refs).through(:references) }
  it { should have_many(:book_cap_refs).through(:references) }
  it { should have_many(:article_refs).through(:references) }
  it { should have_many(:internet_refs).through(:references) }
  it { should have_many(:legislative_refs).through(:references) }
  it { should have_many(:thesis_refs).through(:references) }

  it { should_not allow_mass_assignment_of :name }

  describe 'referencias' do
    let(:reference_type) { [:article_ref, :book_cap_ref, :book_ref, :internet_ref, :legislative_ref,
                            :thesis_ref].sample }

    before(:each) do
      @tcc = Fabricate(:tcc)
      @ref = Fabricate(reference_type)
    end

    after(:each) do
      @tcc.destroy
      @ref.destroy
    end

    it 'should return references' do
      @tcc.references.create(:element => @ref)
      expect(@tcc.references.count).to equal(1)
    end

    it 'should create valid element' do
      @tcc.references.create(:element => @ref)
      expect(@tcc.references.count).to eq(1)
      expect(@tcc.references.first.element.hash).to eq(@ref.hash)

      novo = Fabricate(reference_type)

      @tcc.references.create(:element => novo)
      expect(@tcc.references.count).to eq(2)
      expect(@tcc.references.last.element.hash).not_to eq(@ref.hash)
      expect(@tcc.references.last.element.hash).to eq(novo.hash)
    end
  end

  describe '#tcc_definitions=' do
    let(:tcc_definition) { Fabricate.build(:tcc_definition) }
    let(:chapter_definition) { Fabricate.build(:chapter_definition_without_tcc) }

    after(:all) do
      Tcc.destroy_all
    end

    it 'should accept a tcc definition and store references' do
      tcc.tcc_definition = tcc_definition
      expect(tcc.tcc_definition).not_to be_nil
      expect(tcc.tcc_definition).to eq(tcc_definition)
    end

    it 'should create chapters defined on tcc definition' do
      tcc = Fabricate.build(:tcc_without_dependencies)
      tcc_definition.chapter_definitions << chapter_definition

      expect(tcc_definition.chapter_definitions.size).to eq(1)

      expect(tcc.chapters.size).to eq(0)
      tcc.tcc_definition = tcc_definition
      expect(tcc.chapters.size).to eq(1)
    end

    it 'should update chapters if they already exists' do
      # Cria Tcc e Chapter Definitions necessário pro teste

      3.times do |i|
        chapter_definition = Fabricate.build(:chapter_definition_without_tcc, position: i+1)
        tcc_definition.chapter_definitions << chapter_definition
      end

      expect(tcc_definition).to be_valid
      tcc_definition.save!

      tcc = Fabricate.build(:tcc)
      expect(tcc.chapters.size).to eq(3)

      # garantir que não tem chapter_definition
      expect(tcc.chapters.first.chapter_definition).to be_nil

      # Garante que está tudo válido e persiste no banco
      expect(tcc.tcc_definition).to be_nil
      expect(tcc).to be_valid
      tcc.save!


      # Atribui um tcc_definition ao tcc
      tcc.tcc_definition = tcc_definition
      tcc.save!
      tcc.reload
      expect(tcc.chapters.size).to eq(3)

      # verificar se houve a atualização do campo
      expect(tcc.chapters.first.chapter_definition).not_to be_nil
    end

  end

  describe '#create_dependencies!' do
    let (:tcc) { Fabricate.build(:tcc_without_dependencies) }

    it 'should create abstract when invoked' do
      tcc.create_dependencies!
      expect(tcc.abstract).not_to be_nil
      expect(tcc.abstract).to be_valid
    end

    it 'should not create another abstract when one is available' do
      tcc.create_dependencies!
      abstract = tcc.abstract

      tcc.create_dependencies!
      expect(tcc.abstract).to equal(abstract)
    end

  end

end