# encoding: utf-8
require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate.build(:tcc) }

  it { should respond_to(:leader, :moodle_user, :name, :title, :grade, :defense_date) }

  it { should have_many(:references) }
  it { should have_many(:general_refs).through(:references) }
  it { should have_many(:book_refs).through(:references) }
  it { should have_many(:book_cap_refs).through(:references) }
  it { should have_many(:article_refs).through(:references) }
  it { should have_many(:internet_refs).through(:references) }
  it { should have_many(:legislative_refs).through(:references) }

  it { should validate_uniqueness_of :moodle_user }

  it { should_not allow_mass_assignment_of :name }
  it { should_not allow_mass_assignment_of :leader   }

  describe 'grade' do
    it 'should be zero or higher' do
      tcc.grade = 0
      tcc.should be_valid

      tcc.grade = 0.8
      tcc.should be_valid
    end

    it 'should not be higher than 100' do
      tcc.grade = 101
      tcc.should_not be_valid

      tcc.grade = 100.1
      tcc.should_not be_valid
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
      @tcc.references.count.should equal(1)
    end

    it 'should create valid element' do
      @tcc.references.create(:element => @ref)
      @tcc.references.count.should == 1
      @tcc.references.first.element.hash.should == @ref.hash

      novo = Fabricate(:general_ref)

      @tcc.references.create(:element => novo)
      @tcc.references.count.should == 2
      @tcc.references.last.element.hash.should_not == @ref.hash
      @tcc.references.last.element.hash.should == novo.hash
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
      tcc.tcc_definition.should_not be_nil
      tcc.tcc_definition.should == tcc_definition
    end

    it 'should create hubs defined on tcc definition' do
      tcc = Fabricate.build(:tcc_without_hubs)
      tcc_definition.hub_definitions << hub_definition

      tcc_definition.hub_definitions.size.should == 1

      tcc.hubs.size.should == 0
      tcc.tcc_definition = tcc_definition
      tcc.hubs.size.should == 2
    end

    it 'should create diaries defined on hub definition' do
      tcc = Fabricate.build(:tcc_without_hubs)
      hub_definition.diary_definitions << diary_definition
      tcc_definition.hub_definitions << hub_definition
      tcc.hubs.size.should == 0

      tcc.tcc_definition = tcc_definition
      tcc.hubs.first.diaries.size.should == 1
    end

    it 'should update hubs if they already exists' do
      # Cria Tcc e Hub Definitions necessário pro teste

      3.times do |i|
        hub_definition = Fabricate.build(:hub_definition_without_tcc)
        hub_definition.position = i+1
        tcc_definition.hub_definitions << hub_definition
      end

      tcc_definition.should be_valid
      tcc_definition.save!

      tcc = Fabricate.build(:tcc)
      tcc.hubs.size.should == 3

      # garantir que não tem hub_definition
      tcc.hubs.first.hub_definition.should be_nil

      # Garante que está tudo válido e persiste no banco
      tcc.tcc_definition.should be_nil
      tcc.should be_valid
      tcc.save!


      # Atribui um tcc_definition ao tcc
      tcc.tcc_definition = tcc_definition
      tcc.save!
      tcc.reload
      tcc.hubs.size.should == 6

      # verificar se houve a atualização do campo
      tcc.hubs.first.hub_definition.should_not be_nil
    end

    it 'should update diaries if they already exists' do
      hub_definition.position = 1
      diary_definition.position = 1
      hub_definition.diary_definitions << diary_definition
      tcc_definition.hub_definitions << hub_definition
      tcc_definition.should be_valid
      tcc_definition.save!

      tcc = Fabricate.build(:tcc)
      tcc.should be_valid
      tcc.hubs.first.diaries.first.diary_definition.should be_nil
      tcc.save!

      # contagem em profundidade para garantir que não houve criação
      tcc.hubs.hub_portfolio.each.map { |h| h.diaries }.flatten.size.should == 6

      tcc.tcc_definition = tcc_definition
      tcc.save!
      tcc.reload
      tcc.hubs.hub_portfolio.each.map { |h| h.diaries }.flatten.size.should == 6

      # verificar se houve a atualização do campo
      tcc.hubs.first.diaries.first.diary_definition.should_not be_nil
    end

  end

  describe '#create_dependencies!' do
    let (:tcc) { Fabricate.build(:tcc_without_dependencies) }

    it 'should create presentations when invoked' do
      tcc.create_dependencies!
      tcc.presentation.should_not be_nil
      tcc.presentation.should be_valid
    end

    it 'should not create another presentation when one is available' do
      tcc.create_dependencies!
      presentation = tcc.presentation

      tcc.create_dependencies!
      tcc.presentation.should equal(presentation)
    end

    it 'should create abstract when invoked' do
      tcc.create_dependencies!
      tcc.abstract.should_not be_nil
      tcc.abstract.should be_valid
    end

    it 'should not create another abstract when one is available' do
      tcc.create_dependencies!
      abstract = tcc.abstract

      tcc.create_dependencies!
      tcc.abstract.should equal(abstract)
    end

    it 'should create final considerations when invoked' do
      tcc.create_dependencies!
      tcc.final_considerations.should_not be_nil
      tcc.abstract.should be_valid
    end

    it 'should not create final considerations when one is available' do
      tcc.create_dependencies!
      final_considerations = tcc.final_considerations

      tcc.create_dependencies!
      tcc.final_considerations.should equal(final_considerations)
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