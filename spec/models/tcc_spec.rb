# encoding: utf-8
require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate.build(:tcc) }

  it { should respond_to(:leader, :moodle_user, :name, :title, :grade, :defense_date, :grade_updated_at) }

  it { should have_many(:references) }
  it { should have_many(:general_refs).through(:references) }
  it { should have_many(:book_refs).through(:references) }
  it { should have_many(:book_cap_refs).through(:references) }
  it { should have_many(:article_refs).through(:references) }
  it { should have_many(:internet_refs).through(:references) }
  it { should have_many(:legislative_refs).through(:references) }
  it { should have_many(:thesis_refs).through(:references) }

  it { should validate_uniqueness_of :moodle_user }

  it { should_not allow_mass_assignment_of :name }
  it { should_not allow_mass_assignment_of :leader   }

  describe 'grade' do
    it 'should be zero or higher' do
      tcc.grade = 0
      expect(tcc).to be_valid

      tcc.grade = 0.8
      expect(tcc).to be_valid
    end

    it 'should not be higher than 100' do
      tcc.grade = 101
      expect(tcc).not_to be_valid

      tcc.grade = 100.1
      expect(tcc).not_to be_valid
    end
  end

  describe 'referencias' do
    before(:each) do
      @tcc = Fabricate(:tcc)
      @ref = Fabricate(:general_ref)
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

      novo = Fabricate(:general_ref)

      @tcc.references.create(:element => novo)
      expect(@tcc.references.count).to eq(2)
      expect(@tcc.references.last.element.hash).not_to eq(@ref.hash)
      expect(@tcc.references.last.element.hash).to eq(novo.hash)
    end
  end

  describe '#tcc_definitions=' do
    let(:tcc_definition) { Fabricate.build(:tcc_definition) }
    let(:hub_definition) { Fabricate.build(:hub_definition_without_tcc) }
    let(:diary_definition) { Fabricate.build(:diary_definition_without_hub) }

    after(:all) do
      Tcc.destroy_all
    end

    it 'should accept a tcc definition and store references' do
      tcc.tcc_definition = tcc_definition
      expect(tcc.tcc_definition).not_to be_nil
      expect(tcc.tcc_definition).to eq(tcc_definition)
    end

    it 'should create hubs defined on tcc definition' do
      tcc = Fabricate.build(:tcc_without_hubs)
      tcc_definition.hub_definitions << hub_definition

      expect(tcc_definition.hub_definitions.size).to eq(1)

      expect(tcc.hubs.size).to eq(0)
      tcc.tcc_definition = tcc_definition
      expect(tcc.hubs.size).to eq(2)
    end

    it 'should create diaries defined on hub definition' do
      tcc = Fabricate.build(:tcc_without_hubs)
      hub_definition.diary_definitions << diary_definition
      tcc_definition.hub_definitions << hub_definition
      expect(tcc.hubs.size).to eq(0)

      tcc.tcc_definition = tcc_definition
      expect(tcc.hubs.first.diaries.size).to eq(1)
    end

    it 'should update hubs if they already exists' do
      # Cria Tcc e Hub Definitions necessário pro teste

      3.times do |i|
        hub_definition = Fabricate.build(:hub_definition_without_tcc)
        hub_definition.position = i+1
        tcc_definition.hub_definitions << hub_definition
      end

      expect(tcc_definition).to be_valid
      tcc_definition.save!

      tcc = Fabricate.build(:tcc)
      expect(tcc.hubs.size).to eq(3)

      # garantir que não tem hub_definition
      expect(tcc.hubs.first.hub_definition).to be_nil

      # Garante que está tudo válido e persiste no banco
      expect(tcc.tcc_definition).to be_nil
      expect(tcc).to be_valid
      tcc.save!


      # Atribui um tcc_definition ao tcc
      tcc.tcc_definition = tcc_definition
      tcc.save!
      tcc.reload
      expect(tcc.hubs.size).to eq(6)

      # verificar se houve a atualização do campo
      expect(tcc.hubs.first.hub_definition).not_to be_nil
    end

    it 'should update diaries if they already exists' do
      hub_definition.position = 1
      diary_definition.position = 1
      hub_definition.diary_definitions << diary_definition
      tcc_definition.hub_definitions << hub_definition
      expect(tcc_definition).to be_valid
      tcc_definition.save!

      tcc = Fabricate.build(:tcc)
      expect(tcc).to be_valid
      expect(tcc.hubs.first.diaries.first.diary_definition).to be_nil
      tcc.save!

      # contagem em profundidade para garantir que não houve criação
      expect(tcc.hubs.hub_portfolio.each.map { |h| h.diaries }.flatten.size).to eq(6)

      tcc.tcc_definition = tcc_definition
      tcc.save!
      tcc.reload
      expect(tcc.hubs.hub_portfolio.each.map { |h| h.diaries }.flatten.size).to eq(6)

      # verificar se houve a atualização do campo
      expect(tcc.hubs.first.diaries.first.diary_definition).not_to be_nil
    end

  end

  describe '#create_dependencies!' do
    let (:tcc) { Fabricate.build(:tcc_without_dependencies) }

    it 'should create presentations when invoked' do
      tcc.create_dependencies!
      expect(tcc.presentation).not_to be_nil
      expect(tcc.presentation).to be_valid
    end

    it 'should not create another presentation when one is available' do
      tcc.create_dependencies!
      presentation = tcc.presentation

      tcc.create_dependencies!
      expect(tcc.presentation).to equal(presentation)
    end

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

    it 'should create final considerations when invoked' do
      tcc.create_dependencies!
      expect(tcc.final_considerations).not_to be_nil
      expect(tcc.abstract).to be_valid
    end

    it 'should not create final considerations when one is available' do
      tcc.create_dependencies!
      final_considerations = tcc.final_considerations

      tcc.create_dependencies!
      expect(tcc.final_considerations).to equal(final_considerations)
    end

  end

  describe '#student_name' do

    it 'should return student name without matricula' do
      tcc = Fabricate.build(:tcc_without_dependencies)
      name = tcc.name
      tcc.name += ' (201301010)'
      expect(tcc.student_name).to eq(name)
    end
  end

end