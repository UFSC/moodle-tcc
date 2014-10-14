require 'spec_helper'

describe PersonDecorator do
  let(:person) { Fabricate.build(:person).decorate }

  describe '#name' do
    it 'should return student name without matricula' do
      name = person.object.name
      person.object.name += ' (201301010)'
      expect(person.name).to eq(name)
    end
  end
end
