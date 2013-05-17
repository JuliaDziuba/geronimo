# == Schema Information
#
# Table name: siteworks
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  work_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Sitework do
  let(:site) { FactoryGirl.create(:site) }
  let(:work) { FactoryGirl.create(:work) }
  before { @sw = site.siteworks.build(work_id: work.id) }
  
  subject { @sw }

  it { should respond_to(:site) }
  its(:site) { should == site }

   it { should respond_to(:work) }
  its(:work) { should == work }

  it { should respond_to(:site_id) }
  it { should respond_to(:work_id) }

  it { should be_valid }

   describe "when site_id is not present" do
    before { @sw.site_id = nil }
    it { should_not be_valid }
  end

  describe "when work_id is not present" do
    before { @sw.work_id = nil }
    it { should_not be_valid }
  end

end
