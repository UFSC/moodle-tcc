require 'spec_helper'

describe Authentication do

  describe Authentication::User do

    describe '#instructor?' do

      it 'should return true if instructors role is present' do
        user = Authentication::User.new fake_lti_tp('instructor')
        user.instructor?.should be_true
      end

      it 'should return true if admin role is present' do
        user = Authentication::User.new fake_lti_tp('administrator')
        user.instructor?.should be_true
      end

      it 'should return true if tutor a distancia role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/td')
        user.instructor?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.instructor?.should be_false
      end
    end

    describe '#view_all?' do

      it 'should return true if admin role is present' do
        user = Authentication::User.new fake_lti_tp('administrator')
        user.view_all?.should be_true
      end

      it 'should return true for coordavea moodle\'s roles' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea')
        user.view_all?.should be_true
      end

      it 'should return false for coordcurso, tutoria moodle\'s roles' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso')
        user.view_all?.should be_false
      end

      it 'should return false for tutoria moodle\'s roles' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria')
        user.view_all?.should be_false
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.view_all?.should be_false
      end
    end

    describe '#coordenador_avea?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea')
        user.coordenador_avea?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.coordenador_avea?.should be_false
      end
    end

    describe '#coordenador_curso?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso')
        user.coordenador_curso?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.coordenador_curso?.should be_false
      end
    end

    describe '#coordenador_tutoria?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria')
        user.coordenador_tutoria?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.coordenador_tutoria?.should be_false
      end
    end

    describe '#tutor?' do
      it 'should return true if role tutor a distancia is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/td')
        user.tutor?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.tutor?.should be_false
      end
    end

    describe '#orientador?' do
      it 'should return true if role orientador is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
        user.orientador?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.orientador?.should be_false
      end
    end

  end

end