require 'spec_helper'

describe SyncTcc do

  context 'when a people is created' do

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

  context 'when a TCC is created' do

    let(:tcc_definition) { Fabricate(:tcc_definition) }
    let(:sync) { SyncTcc.new(tcc_definition) }
    let(:_student) { Fabricate.build(:person) }
    let(:_tutor) { Fabricate.build(:person) }
    let(:_tutor_updated) { Fabricate.build(:person) }
    let(:_orientador) { Fabricate.build(:person) }

    it 'expects to be created' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [_student.moodle_id] }
      allow(sync).to receive(:get_tutor) { _student }
      allow(sync).to receive(:get_orientador) { _student }
      sync.call
      expect(Tcc.find_by_tcc_definition_id tcc_definition).to be_a(Tcc)
    end

    it 'expects to be updated' do
      allow(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [255] }
      allow(sync).to receive(:get_tutor) { _tutor }
      allow(sync).to receive(:get_orientador) { _orientador }
      sync.call
      allow(sync).to receive(:get_tutor) { _tutor_updated }
      sync.call
      moodle_id_tutor = _tutor.moodle_id
      expect {Tcc.find_by_student_id 255}.to change{ moodle_id_tutor }.from(moodle_id_tutor).to(_tutor_updated
                                                                                                .moodle_id)
    end
  end
end