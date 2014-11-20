# == Schema Information
#
# Table name: workcategories
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  name             :string(255)
#  artist_statement :string(1000)
#  parent_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Workcategory do

  let(:user) { FactoryGirl.create(:user) }
  before { @workcategory = user.workcategories.build(name: "Wooden Fruit", artist_statement: "Handmade wooden fruit") }
  
  subject { @workcategory }

  its(:user) { should == user }

  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:name) }
  it { should respond_to(:artist_statement) }
  it { should respond_to(:parent_id) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }

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

  describe "with artist_statement that is too long" do
    before { @workcategory.artist_statement = "a" * 1001 }
    it { should_not be_valid }
  end

end
