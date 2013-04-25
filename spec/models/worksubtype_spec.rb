# == Schema Information
#
# Table name: worksubtypes
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  worktype_id :integer
#

require 'spec_helper'

describe Worksubtype do

  let(:user) { FactoryGirl.create(:user) }
  let(:worktype) { FactoryGirl.create(:worktype, user: user) }
  before { @worksubtype = worktype.worksubtypes.build(name: "Wooden Grapes") }
  
  subject { @worksubtype }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:worktype_id) }
  it { should respond_to(:worktype) }
  its(:worktype) { should == worktype }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to worktype_id" do
      expect do
        Worksubtype.new(worktype_id: worktype.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when worktype_id is not present" do
    before { @worksubtype.worktype_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @worksubtype.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @worksubtype.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @worksubtype.description = "a" * 151 }
    it { should_not be_valid }
  end
end
