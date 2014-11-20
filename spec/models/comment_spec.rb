# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  type_id    :integer
#  name       :string(255)
#  date       :date
#  comment    :string(2000)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Comment do
  let(:u) { FactoryGirl.create(:user) }
  before { @c = u.comments.create(type_id: 1, name: "Test comment", date: "2014-09-29", comment: "A comment that is important.") }
  
  subject { @c }

  it { should respond_to(:user) }
  its(:user) { should == u }

  it { should respond_to(:type_id) }
  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:comment) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user" do
      expect do
        Comment.new(user: u.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @c.user_id = nil}
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @c.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @c.name = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when date is not present" do
    before { @c.date = nil}
    it { should_not be_valid }
  end

  describe "when comment is not present" do
    before { @c.comment = nil}
    it { should_not be_valid }
  end

  describe "with blank comment" do
    before { @c.comment = " " }
    it { should_not be_valid }
  end
end
