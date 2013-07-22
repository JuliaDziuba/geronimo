# == Schema Information
#
# Table name: venuecategories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Venuecategory do
  before { @venuecategory = Venuecategory.new(name: "Gallery", description: "Galleries anywhere in the US") }
  
  subject { @venuecategory }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "when name is not present" do
    before { @venuecategory.name = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @venuecategory.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @venuecategory.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @venuecategory.description = "a" * 151 }
    it { should_not be_valid }
  end
  
end
