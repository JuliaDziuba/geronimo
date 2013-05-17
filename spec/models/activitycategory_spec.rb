# == Schema Information
#
# Table name: activitycategories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  final       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Activitycategory do
    let(:user) { FactoryGirl.create(:user) }
  before { @activitycategory = user.activitycategories.build(name: "Sale", status: "Sold", description: "Sold a piece to a client", final: false) }
  
  subject { @activitycategory }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:status) }
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
    before { @activitycategory.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @activitycategory.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @activitycategory.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @activitycategory.description = "a" * 151 }
    it { should_not be_valid }
  end

  describe "with status that is too long" do
    before { @activitycategory.status = "a" * 26 }
    it { should_not be_valid }
  end
end
