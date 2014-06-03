# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  date         :date
#  note         :string(255)
#  notable_id   :integer
#  notable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Note do
  let(:user) { FactoryGirl.create(:user) }
  before { @note = user.notes.build(notable: user, note: "Test user association with note.", date: "2014-01-01") }
  
  subject { @note }

  it { should respond_to(:date) }
  it { should respond_to(:note) }
  it { should respond_to(:notable_id) }
  it { should respond_to(:notable_type) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

  it { should be_valid }

  describe "when notable_id is not present" do
    before { @note.notable_id = nil}
    it { should_not be_valid }
  end

  describe "when notable_type is not present" do
    before { @note.notable_type = nil}
    it { should_not be_valid }
  end

  describe "when due is not present" do
    before { @note.date = nil}
    it { should_not be_valid }
  end

  describe "when note is not present" do
    before { @note.note = nil}
    it { should_not be_valid }
  end

end
