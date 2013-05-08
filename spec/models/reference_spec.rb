require 'spec_helper'

describe Reference do

  it { should belong_to(:tcc) }
  it { should belong_to(:element) }

  it { should allow_mass_assignment_of(:element) }

  it { should validate_presence_of(:tcc_id) }
  it { should validate_presence_of(:element_id) }

end
