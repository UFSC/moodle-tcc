require 'spec_helper'

describe SyncTcc do

  let(:tcc_definition) { Fabricate(:tcc_definition) }
  let(:sync) { SyncTcc.new(tcc_definition) }
  let(:other_sync) { SyncTcc.new(tcc_definition) }
  let(:student) { Fabricate(:person) }
  let(:other_student) { Fabricate(:person) }
  let(:tutor) { Fabricate.build(:person) }
  let(:orientador) { Fabricate.build(:person) }

  context 'people synchronization' do
    let(:student_attributes) { Fabricate.attributes_for(:person) }


    context 'when a student is already present' do
      before do
        allow(sync).to receive(:get_tcc_tutor) { tutor }
        allow(sync).to receive(:get_tcc_orientador) { orientador }
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
      allow(sync).to receive(:get_tcc_tutor) { tutor }
      allow(sync).to receive(:get_tcc_orientador) { orientador }

      sync.send(:get_tcc_students)

      expect(Person.where(moodle_id: attrs[:moodle_id]).exists?).to be true
    end
  end


  context 'when a TCC is created' do
    let(:_tutor) { Fabricate.build(:person) }
    let(:_orientador) { Fabricate.build(:person) }
    let(:_tutor_updated) { Fabricate.build(:person) }
    let(:student_attributes) { Fabricate.attributes_for(:person) }

    before do
      allow(sync).to receive(:get_tcc_tutor) { tutor }
      allow(sync).to receive(:get_tcc_orientador) { orientador }
    end

    it 'expects to be created' do
      sync.send(:synchronize_tcc, student)

      expect(Tcc.where(student: student).exists?).to be true
    end

    it 'expects to be updated' do

      sync.send(:synchronize_tcc, student)
      attrs = student
      fake_attributes = OpenStruct.new({id: attrs[:moodle_id],
                                        name: attrs[:name],
                                        email: attrs[:email],
                                        username: attrs[:moodle_username]})

      sync.send(:synchronize_tcc, other_student)

      allow_any_instance_of(MoodleAPI::MoodleUser).to receive(:get_students_by_course) { [student.id] }
      allow_any_instance_of(MoodleAPI::MoodleUser).to receive(:find_users_by_field) { fake_attributes }

      sync.send(:get_tcc_students)

      @tcc = Tcc.find_by_student_id(student.id)
      moodle_id_orientador = @tcc.orientador.moodle_id
      @other_tcc = Tcc.find_by_student_id(other_student.id)
      moodle_id_other_orientador = @other_tcc.orientador.moodle_id
      @course_id = @tcc.tcc_definition.course_id
      @other_course_id = @other_tcc.tcc_definition.course_id

      sync.call
      expect(@tcc.orientador.moodle_id).to be(moodle_id_orientador)
      allow(other_sync).to receive(:get_tutor) { _tutor_updated }
      @tcc.orientador = @other_tcc.orientador
      @tcc.save!
      expect(@tcc.orientador.moodle_id).to be(moodle_id_other_orientador)

      sync.call
      expect(@tcc.orientador.moodle_id).to be(moodle_id_orientador)
    end
  end
end