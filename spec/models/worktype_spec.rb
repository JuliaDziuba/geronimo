# == Schema Information
#
# Table name: worktypes
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#

require 'spec_helper'

describe Worktype do

  let(:user) { FactoryGirl.create(:user) }
  before { @worktype = user.worktypes.build(name: "Wooden Fruit", description: "Handmade wooden fruit") }
  
  subject { @worktype }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should respond_to(:worktypesubs) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Worktype.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @worktype.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @worktype.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @worktype.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @worktype.description = "a" * 151 }
    it { should_not be_valid }
  end

end
