# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  phone           :string(255)
#  address_street  :string(255)
#  address_city    :string(255)
#  address_state   :string(255)
#  address_zipcode :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Client do
  let(:user) { FactoryGirl.create(:user) }
  before { @client = user.clients.build(name: "Susie Deep Pockets") }
  
  subject { @client }

  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should respond_to(:user) }
  it { should respond_to(:address_city) }
  it { should respond_to(:address_state) }
  it { should respond_to(:address_street) }
  it { should respond_to(:address_zipcode) }
  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:phone) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user" do
      expect do
        Client.new(user: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @client.user_id = nil}
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { @client.name = " " }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @client.name = "a" * 31 }
    it { should_not be_valid }
  end
end
