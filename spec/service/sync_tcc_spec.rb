require 'spec_helper'

describe SyncTcc do

  let(:tcc_definition) { Fabricate(:tcc_definition) }
  let(:sync) { SyncTcc.new(tcc_definition) }
  let(:student) { Fabricate(:person) }
  let(:tutor) { Fabricate.build(:person) }
  let(:orientador) { Fabricate.build(:person) }

  context 'people synchronization' do
    let(:student_attributes) { Fabricate.attributes_for(:person) }


    context 'when a student is already present' do
      before do
        allow(sync).to receive(:get_tutor) { tutor }
        allow(sync).to receive(:get_orientador) { orientador }
      end

      it 'expects tutor to be created' do
        sync.send(:synchronize_tcc, student)

        expect(Person.find_by_moodle_id tutor.moodle_id).to be_a(Person)
      end

      it 'expects orientador to be created' do
        sync.send(:synchronize_tcc, student)

        expect(Person.find_by_moodle_id orientador.moodle_id).to be_a(Person)
      end
    end

    it 'expects student to be created' do
      attrs = student_attributes
      fake_attributes = OpenStruct.new({id: attrs[:moodle_id],
                                        name: attrs[:name],
                                        email: attrs[:email],
                                        username: attrs[:moodle_username]})

      allow_any_instance_of(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [attrs[:moodle_id]] }
      allow_any_instance_of(MoodleAPI::MoodleUser).to receive(:find_users_by_field) { fake_attributes }
      allow(sync).to receive(:get_tutor) { tutor }
      allow(sync).to receive(:get_orientador) { orientador }

      sync.send(:get_students)

      expect(Person.where(moodle_id: attrs[:moodle_id]).exists?).to be true
    end
  end


  context 'when a TCC is created' do
    let(:_tutor_updated) { Fabricate.build(:person) }

    before do
      allow(sync).to receive(:get_tutor) { tutor }
      allow(sync).to receive(:get_orientador) { orientador }
    end

    it 'expects to be created' do
      sync.send(:synchronize_tcc, student)

      expect(Tcc.where(student: student).exists?).to be true
    end

    xit 'expects to be updated' do
      allow_any_instance_of(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [255] }
      allow(sync).to receive(:get_tutor) { _tutor }
      allow(sync).to receive(:get_orientador) { _orientador }

      sync.call

      allow_any_instance_of(sync).to receive(:get_tutor) { _tutor_updated }

      sync.call

      moodle_id_tutor = _tutor.moodle_id
      expect { Tcc.find_by_student_id 255 }.to change { moodle_id_tutor }.from(moodle_id_tutor).to(_tutor_updated.moodle_id)
    end
  end
end