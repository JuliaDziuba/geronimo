# == Schema Information
#
# Table name: activitycategories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  final       :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Activitycategory do
  before { @activitycategory = Activitycategory.new(name: "Sale", status: "Sold", description: "Sold a piece to a client", final: false) }
  
  subject { @activitycategory }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:status) }

  it { should be_valid }

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

   # Activitycategories and activities

  describe "activitycategory associations" do

    let!(:b_activitycategory) do 
      FactoryGirl.create(:activitycategory, name: "Sale", description: "Sale to a client.", final: true)
    end
    let!(:a_activitycategory) do
      FactoryGirl.create(:activitycategory, name: "Consignment", description: "Consigned to a venue.", final: false)
    end

    it "should have the right types in the right order" do
      Activitycategory.order_name.all.should == [a_activitycategory, b_activitycategory]
    end

  end
end
