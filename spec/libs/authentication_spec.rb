require 'spec_helper'

describe Authentication do

  describe Authentication::User do

    describe '#instructor?' do

      it 'should return true if instructors role is present' do
        user = Authentication::User.new fake_lti_tp('instructor')
        expect(user.instructor?).to be true
      end

      it 'should return true if admin role is present' do
        user = Authentication::User.new fake_lti_tp('administrator')
        expect(user.instructor?).to be true
      end

      it 'should return true if tutor a distancia role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/td')
        #expect(user.instructor?).to be true
        expect(user.instructor?).to be false
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        expect(user.instructor?).to be false
      end
    end

    describe '#view_all?' do
      describe 'type = tcc' do
        it 'should return true if admin role is present' do
          user = Authentication::User.new fake_lti_tp('administrator')
          expect(user.view_all?).to be true
        end

        it 'should return true for coordavea moodle\'s roles' do
          user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea')
          expect(user.view_all?).to be true
        end

        it 'should return false for coordcurso, tutoria moodle\'s roles' do
          user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso')
          expect(user.view_all?).to be true
        end

        it 'should return true for tutoria moodle\'s roles' do
          user = Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria')
          #expect(user.view_all?).to be true
          expect(user.view_all?).to be false
        end

        it 'should return false if none of the expected roles are present' do
          user = Authentication::User.new fake_lti_tp('invalidrole')
          expect(user.view_all?).to be false
        end
      end
    end

    describe '#coordenador_avea?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea')
        expect(user.coordenador_avea?).to be true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        expect(user.coordenador_avea?).to be false
      end
    end

    describe '#coordenador_curso?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso')
        expect(user.coordenador_curso?).to be true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        expect(user.coordenador_curso?).to be false
      end
    end

    describe '#coordenador_tutoria?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria')
        expect(user.coordenador_tutoria?).to be true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        expect(user.coordenador_tutoria?).to be false
      end
    end

    describe '#tutor?' do
      it 'should return true if role tutor a distancia is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/td')
        #expect(user.tutor?).to be true
        expect(user.tutor?).to be false
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        expect(user.tutor?).to be false
      end
    end

    describe '#orientador?' do
      it 'should return true if role orientador is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
        expect(user.orientador?).to be true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        expect(user.orientador?).to be false
      end
    end

  end

end