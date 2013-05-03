# == Schema Information
#
# Table name: venuecategories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Venuecategory do
  let(:user) { FactoryGirl.create(:user) }
  before { @venuecategory = user.venuecategories.build(name: "Gallery", description: "Galleries anywhere in the US") }
  
  subject { @venuecategory }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Venuecategory.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @venuecategory.user_id = nil }
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
