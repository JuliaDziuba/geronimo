# == Schema Information
#
# Table name: documents
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  name                  :string(255)
#  munged_name           :string(255)
#  category              :string(255)
#  date                  :date
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
#  include_dimensions    :boolean          default(FALSE)
#  include_materials     :boolean          default(FALSE)
#  include_description   :boolean          default(FALSE)
#  include_income        :boolean          default(FALSE)
#  include_retail        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  include_quantity      :boolean          default(FALSE)
#


require 'spec_helper'

describe Document do
  let(:user) { FactoryGirl.create(:user) }
  let(:c)    { FactoryGirl.create(:client, user: user) }
  before { @doc = user.documents.build(
    name: "Smith Invoice", maker: "Artist Name", date:Date::today, category:Document::INVOICE, subject:c, date_start:"2011-01-01", date_end:"2011-01-01",
    include_image: true, include_title: true, include_inventory_id: true, include_creation_date: true, 
    include_quantity: true, include_dimensions: true, include_materials: true, include_description: true, 
    include_income: true, include_retail: true) }
  
  subject { @doc }

  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should respond_to(:user) }
  it { should respond_to(:name) }
  it { should respond_to(:munged_name) }
  it { should respond_to(:category) }
  it { should respond_to(:date) }
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
  it { should respond_to(:include_materials) }
  it { should respond_to(:include_description) }
  it { should respond_to(:include_income) }
  it { should respond_to(:include_retail) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  pending { it { should have_constant(:CONSIGNMENT) } }
  pending { it { should have_constant(:INVOICE) } }
  pending { it { should have_constant(:PORTFOLIO) } }
  pending { it { should have_constant(:PRICE) } }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user" do
      expect do
        Document.new(user: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @doc.user_id = nil}
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @doc.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @doc.name = "a" * 71 }
    it { should_not be_valid }
  end
end
