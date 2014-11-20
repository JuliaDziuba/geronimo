# == Schema Information
#
# Table name: activities
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  date_start            :date
#  date_end              :date
#  subject               :text
#  maker                 :string(255)
#  maker_medium          :string(255)
#  maker_phone           :string(255)
#  maker_email           :string(255)
#  maker_site            :string(255)
#  maker_address_street  :string(255)
#  maker_address_city    :string(255)
#  maker_address_state   :string(255)
#  maker_address_zipcode :string(255)
#  include_image         :boolean          default(FALSE)
#  include_title         :boolean          default(FALSE)
#  include_inventory_id  :boolean          default(FALSE)
#  include_creation_date :boolean          default(FALSE)
#  include_quantity      :boolean          default(FALSE)
#  include_dimensions    :boolean          default(FALSE)
#  include_materials     :boolean          default(FALSE)
#  include_description   :boolean          default(FALSE)
#  include_income        :boolean          default(FALSE)
#  include_retail        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  client_id             :integer
#  venue_id              :integer
#  category_id           :integer
#

require 'spec_helper'

describe Activity do
  let(:u) { FactoryGirl.create(:user) }
  let(:v) { FactoryGirl.create(:venue, user: u) }
  let(:c) { FactoryGirl.create(:client, user: u) }

  describe "when the activity consumer is a client" do 

    before do
      @activity_consumer_client = u.activities.create(category_id: 1, venue_id: v.id, client_id: c.id, date_start: '2013-01-01') 
    end

    subject { @activity_consumer_client }

    it { should respond_to(:user) }
    its(:user) { should == u }

    it { should respond_to(:venue) }
  #  its(:venue)(:name) { should == Venue::DEFAULT }

    it { should respond_to(:client) }
    its(:client) { should == c }

    it { should respond_to(:user_id) }
    it { should respond_to(:client_id) }
    it { should respond_to(:venue_id) }
    it { should respond_to(:category_id) }
    it { should respond_to(:date_start) }
    it { should respond_to(:date_end) }
    it { should respond_to(:subject) }
    it { should respond_to(:maker) }
    it { should respond_to(:maker_medium) }
    it { should respond_to(:maker_phone) }
    it { should respond_to(:maker_email) }
    it { should respond_to(:maker_site) }
    it { should respond_to(:maker_address_street) }
    it { should respond_to(:maker_address_city) }
    it { should respond_to(:maker_address_state) }
    it { should respond_to(:maker_address_zipcode) }
    it { should respond_to(:include_image) }
    it { should respond_to(:include_title) }
    it { should respond_to(:include_inventory_id) }
    it { should respond_to(:include_creation_date) }
    it { should respond_to(:include_quantity) }
    it { should respond_to(:include_dimensions) }
    it { should respond_to(:include_income) }
    it { should respond_to(:include_retail) }
  	it { should respond_to(:created_at) }
  	it { should respond_to(:updated_at) }

    it { should be_valid }
  end
  describe "when the activity consumer is a venue" do
    before do 
      @activity_consumer_venue = u.activities.create(category_id: 2, venue_id: v.id, client_id: c.id, date_start: '2013-01-01')
    end

    subject { @activity_consumer_venue }

    it {should respond_to(:venue) }
    its(:venue) { should == v }

    it { should respond_to(:client) }
  #  its(:client)(:name) { should == Client::DEFAULT }
  end
end
