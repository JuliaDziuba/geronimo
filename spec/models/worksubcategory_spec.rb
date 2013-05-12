# == Schema Information
#
# Table name: worksubcategories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  workcategory_id :integer
#

require 'spec_helper'

describe Worksubcategory do

  let(:user) { FactoryGirl.create(:user) }
  let(:workcategory) { FactoryGirl.create(:workcategory, user: user) }
  before { @worksubcategory = workcategory.worksubcategories.build(name: "Wooden Grapes") }
  
  subject { @worksubcategory }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:workcategory_id) }
  it { should respond_to(:workcategory) }
  its(:workcategory) { should == workcategory }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to workcategory_id" do
      expect do
        Worksubcategory.new(workcategory_id: workcategory.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when workcategory_id is not present" do
    before { @worksubcategory.workcategory_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @worksubcategory.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @worksubcategory.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @worksubcategory.description = "a" * 501 }
    it { should_not be_valid }
  end
end
