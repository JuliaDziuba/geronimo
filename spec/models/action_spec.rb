# == Schema Information
#
# Table name: actions
#
#  id              :integer          not null, primary key
#  due             :date
#  action          :string(255)
#  actionable_id   :integer
#  actionable_type :string(255)
#  complete        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Action do
  let(:user) { FactoryGirl.create(:user) }
  before { @action = user.actions.build(actionable: user, action: "Test user association.", due: "2014-01-01", complete: false) }
  
  subject { @action }

  it { should respond_to(:due) }
  it { should respond_to(:action) }
  it { should respond_to(:actionable) }
  it { should respond_to(:actionable_id) }
  it { should respond_to(:actionable_type) }
  it { should respond_to(:complete) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "when actionable_id is not present" do
    before { @action.actionable_id = nil}
    it { should_not be_valid }
  end

  describe "when actionable_type is not present" do
    before { @action.actionable_type = nil}
    it { should_not be_valid }
  end

  describe "when due is not present" do
    before { @action.due = nil}
    it { should_not be_valid }
  end

  describe "when action is not present" do
    before { @action.action = nil}
    it { should_not be_valid }
  end

  describe "when complete is not present" do
    before { @action.complete = nil}
    it { should_not be_valid }
  end

end
