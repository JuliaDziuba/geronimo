# == Schema Information
#
# Table name: activities
#
#  id                  :integer          not null, primary key
#  activitycategory_id :integer
#  venue_id            :integer
#  client_id           :integer
#  work_id             :integer
#  date_start          :date
#  date_end            :date
#  income_wholesale    :decimal(, )
#  income_retail       :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Activity do
  let(:user) { FactoryGirl.create(:user) }
  let(:wc)   { FactoryGirl.create(:workcategory, user: user) }
  let(:wsc)  { FactoryGirl.create(:worksubcategory, workcategory: wc) }
  let(:w)    { FactoryGirl.create(:work, worksubcategory: wsc) }
  let(:vc)   { FactoryGirl.create(:venuecategory, user: user) }
  let(:v)    { FactoryGirl.create(:venue, venuecategory: vc) }
  let(:ac)   { FactoryGirl.create(:activitycategory, user: user) }
  before { @activity = ac.activities.build(work_id: w, venue_id: v) }
  
  subject { @activity }
 
  it { should respond_to(:activitycategory) }
  its(:activitycategory) { should == ac }

  it { should respond_to(:work) }
  its(:work) { should == w }

  it { should respond_to(:venue) }
  its(:venue) { should == v }

	it { should respond_to(:user) }
  it { should respond_to(:activitycategory_id) }
  it { should respond_to(:venue_id) }
  it { should respond_to(:client_id) }
  it { should respond_to(:work_id) }
  it { should respond_to(:date_start) }
  it { should respond_to(:date_end) }
  it { should respond_to(:income_wholesale) }
  it { should respond_to(:income_retail) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "when activitycategory_id is not present" do
    before { @activity.activitycategory_id = nil}
    it { should_not be_valid }
  end

  describe "when workcategory_id is not present" do
    before { @activity.work_id = nil}
    it { should_not be_valid }
  end

   describe "when venuecategory_id is not present" do
    before { @activity.venue_id = nil}
    it { should_not be_valid }
  end 
end
