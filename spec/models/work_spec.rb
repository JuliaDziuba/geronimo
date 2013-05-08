# == Schema Information
#
# Table name: works
#
#  id                 :integer          not null, primary key
#  worksubcategory_id :integer
#  inventory_id       :string(255)
#  title              :string(255)
#  creation_date      :date
#  expense_hours      :decimal(, )
#  expense_materials  :decimal(, )
#  income_wholesale   :decimal(, )
#  income_retail      :decimal(, )
#  description        :string(255)
#  dimention1         :decimal(, )
#  dimention2         :decimal(, )
#  dimention_units    :string(255)
#  path_image1        :string(255)
#  path_small_image1  :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe Work do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:wc) { FactoryGirl.create(:workcategory, user: user) }
  let(:wsc) { FactoryGirl.create(:worksubcategory, workcategory: wc) }
  before { @work = wsc.works.build(title: "A Day in the Life", description: "Handmade wooden fruit") }
  
  subject { @work }

  it { should respond_to(:user) }
  it { should respond_to(:workcategory) }
  it { should respond_to(:worksubcategory) }
  its(:worksubcategory) { should == wsc }

  it { should respond_to(:worksubcategory_id) }
  it { should respond_to(:inventory_id) }
  it { should respond_to(:title) }
  it { should respond_to(:creation_date) }
  it { should respond_to(:expense_hours) }
  it { should respond_to(:expense_materials) }
  it { should respond_to(:income_wholesale) }
  it { should respond_to(:income_retail) }
  it { should respond_to(:description) }
  it { should respond_to(:dimention1) }
  it { should respond_to(:dimention2) }
  it { should respond_to(:dimention_units) }
  it { should respond_to(:path_image1) }
  it { should respond_to(:path_small_image1) }
	it { should respond_to(:path_image1) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user" do
      expect do
        Work.new(user: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when worksubcategory_id is not present" do
    before { @work.worksubcategory_id = nil }
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { @work.title = " " }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @work.title = "a" * 31 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @work.description = "a" * 301 }
    it { should_not be_valid }
  end

end
