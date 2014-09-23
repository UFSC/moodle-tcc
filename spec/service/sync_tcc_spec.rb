require 'spec_helper'

describe SyncTcc do

  context 'People creation' do

    let(:tcc_definition) { Fabricate(:tcc_definition) }
    let(:sync) { SyncTcc.new(tcc_definition) }
    let(:student) { Fabricate.build(:person) }
    let(:tutor) { Fabricate.build(:person) }
    let(:orientador) { Fabricate.build(:person) }

    it 'expects tutor to be created' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [tutor.moodle_id] }
      allow(sync).to receive(:get_tutor) { tutor }
      allow(sync).to receive(:get_orientador) { orientador }
      sync.call
      expect(Person.find_by_moodle_id tutor.moodle_id).to be_a(Person)
    end

    it 'expects orientador to be created' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [orientador.moodle_id] }
      allow(sync).to receive(:get_tutor) { tutor }
      allow(sync).to receive(:get_orientador) { orientador }
      sync.call
      expect(Person.find_by_moodle_id orientador.moodle_id).to be_a(Person)
    end

    it 'expects student to be created' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [student.moodle_id] }
      allow(sync).to receive(:get_tutor) { tutor }
      allow(sync).to receive(:get_orientador) { orientador }
      sync.call
      expect(Person.find_by_moodle_id student.moodle_id).to be_a(Person)
    end
  end

  context 'TCC' do

    let(:tcc_definition) { Fabricate(:tcc_definition) }
    let(:sync) { SyncTcc.new(tcc_definition) }
    let(:tcc) { Fabricate.build(:tcc) }
    let(:_student) { Fabricate.build(:person) }

    it 'expects to be created' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [_student.moodle_id] }
      allow(sync).to receive(:get_tutor) { _student }
      allow(sync).to receive(:get_orientador) { _student }
      sync.call
      expect(Tcc.find_by_tcc_definition_id tcc_definition).to be_a(Tcc)
    end

    it 'expects to be updated' do
    end

    it 'expects to not duplicate when updated' do
    end
  end

end