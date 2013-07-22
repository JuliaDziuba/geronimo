# == Schema Information
#
# Table name: venues
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  venuecategory_id :integer
#  name             :string(255)
#  munged_name      :string(255)
#  phone            :integer
#  address_street   :string(255)
#  address_city     :string(255)
#  address_state    :string(255)
#  address_zipcode  :integer
#  email            :string(255)
#  site             :string(255)
#  share_makers     :boolean          default(FALSE)
#  share_public     :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Venue do
  let(:vc) { FactoryGirl.create(:venuecategory) }
  let(:user) { FactoryGirl.create(:user) }
  before { @venue = user.venues.build(name: "Last Stop", venuecategory_id: vc.id) }
  
  subject { @venue }

  its(:user) { should == user }
  it { should respond_to(:user) }

  it { should respond_to(:user_id) }
  it { should respond_to(:venuecategory_id) }
  it { should respond_to(:name) }
  it { should respond_to(:munged_name) }
  it { should respond_to(:phone) }
  it { should respond_to(:address_street) }
  it { should respond_to(:address_city) }
  it { should respond_to(:address_state) }
  it { should respond_to(:address_zipcode) }
  it { should respond_to(:email) }
  it { should respond_to(:site) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user" do
      expect do
        Venue.new(user: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @venue.user_id = nil}
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @venue.name = nil}
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @venue.name = " " }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @venue.name = "a" * 31 }
    it { should_not be_valid }
  end
    
end
