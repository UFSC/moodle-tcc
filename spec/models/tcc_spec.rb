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

  describe 'grade' do
    it 'should be less than or equal to 1' do
      tcc.grade = 0.8
      tcc.should be_valid
    end

    it 'should not be higher than 1' do
      tcc.grade = 2
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
      tcc.hubs.size.should == 1
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
      tcc = Fabricate.build(:tcc)
      tcc_definition.hub_definitions << hub_definition
      tcc.hubs.size.should == 3

      tcc.tcc_definition = tcc_definition
      tcc.hubs.size.should == 3

      # verificar se houve a atualização do campo
      tcc.hubs.first.hub_definition.should be_nil
      tcc.tcc_definition = tcc_definition
      tcc.hubs.first.hub_definition.should_not be_nil
    end

    it 'should update diaries if they already exists' do
      tcc = Fabricate.build(:tcc)
      hub_definition.diary_definitions << diary_definition
      tcc_definition.hub_definitions << hub_definition

      # contagem em profundidade para garantir que não houve criação
      tcc.hubs.each.map { |h| h.diaries }.flatten.size.should == 6

      tcc.tcc_definition = tcc_definition
      tcc.hubs.each.map { |h| h.diaries }.flatten.size.should == 6

      # verificar se houve a atualização do campo
      tcc.hubs.first.diaries.first.diary_definition.should be_nil
      tcc.tcc_definition = tcc_definition
      tcc.hubs.first.diaries.first.diary_definition.should_not be_nil
    end
  end

end
