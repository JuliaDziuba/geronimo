
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
