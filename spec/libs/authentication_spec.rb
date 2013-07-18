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

      it 'should return true for coordcurso, tutoria moodle\'s roles' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso')
        user.view_all?.should be_true
      end

      it 'should return true for tutoria moodle\'s roles' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria')
        user.view_all?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.view_all?.should be_false
      end
    end

    describe '#coordavea?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea')
        user.coordavea?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.coordavea?.should be_false
      end
    end

    describe '#coordcurso?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso')
        user.coordcurso?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.coordcurso?.should be_false
      end
    end

    describe '#tutoria?' do
      it 'should return true if role is present' do
        user = Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria')
        user.tutoria?.should be_true
      end

      it 'should return false if none of the expected roles are present' do
        user = Authentication::User.new fake_lti_tp('invalidrole')
        user.tutoria?.should be_false
      end
    end
  end

end