require 'spec_helper'

describe SyncTcc do

  context 'People creation' do

    let(:tcc_definition) { Fabricate(:tcc_definition) }
    let(:sync) { SyncTcc.new(tcc_definition) }
    let(:student) { Fabricate.build(:person) }
    let(:tutor) { Fabricate.build(:person) }
    let(:orientador) { Fabricate.build(:person) }

    it 'expects tutor to be created'

    it 'expects orientador to be created'

    it 'expects student to be created' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { student.moodle_id }
      allow(sync).to receive(:get_tutor) { tutor }
      allow(sync).to receive(:get_orientador) { orientador }

      sync.call

      expect(Person.find_by_moodle_id student.moodle_id).to be_a(Person)
    end



  end

  context 'TCC' do

    it 'expects to be created' do
      allow(SyncTcc).to receive(:get_students) { [person] }
    end

    it 'expects to be updated'

    it 'expects to not duplicate when updated'

  end

end