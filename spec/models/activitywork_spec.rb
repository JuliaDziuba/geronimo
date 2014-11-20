# == Schema Information
#
# Table name: activityworks
#
#  id          :integer          not null, primary key
#  activity_id :integer
#  work_id     :integer
#  income      :decimal(, )
#  retail      :decimal(, )
#  sold        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  quantity    :integer
#

require 'spec_helper'

describe Activitywork do
  let(:u) { FactoryGirl.create(:user) }
  let(:w) { FactoryGirl.create(:work, user: u) }
  let(:v) { FactoryGirl.create(:venue, user: u) }
  let(:c) { FactoryGirl.create(:client, user: u) }
  let(:a) { FactoryGirl.create(:activity, user: u, category_id: 2, venue: v, client: c) }
  before do
    @aw = u.activityworks.create(activity_id: a.id, work_id: w.id, quantity: 2)
  end
  
  subject { @aw }

  it { should respond_to(:user) }
  its(:user) { should == u }

  it { should respond_to(:work) }
  its(:work) { should == w }

  it { should respond_to(:venue) }
  its(:venue) { should == v }

  it { should respond_to(:client) }
  its(:client) { should == c }

  it { should respond_to(:user_id) }
  it { should respond_to(:activity_id) }
  it { should respond_to(:client_id) }
  it { should respond_to(:venue_id) }
  it { should respond_to(:income) }
  it { should respond_to(:retail) }
  it { should respond_to(:sold) }
  it { should respond_to(:quantity) }
  it { should respond_to(:date_start) }
  it { should respond_to(:date_end) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
	
	it { should be_valid }

end
