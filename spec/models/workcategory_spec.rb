# == Schema Information
#
# Table name: workcategories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#

require 'spec_helper'

describe Workcategory do

  let(:user) { FactoryGirl.create(:user) }
  before { @workcategory = user.workcategories.build(name: "Wooden Fruit", description: "Handmade wooden fruit") }
  
  subject { @workcategory }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should respond_to(:worksubcategories) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Workcategory.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @workcategory.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @workcategory.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @workcategory.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @workcategory.description = "a" * 151 }
    it { should_not be_valid }
  end

end
