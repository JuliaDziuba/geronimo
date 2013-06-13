# == Schema Information
#
# Table name: sitevenues
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  venue_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Sitevenue do
  before { pending }
  let(:site) { FactoryGirl.create(:site) }
  let(:venue) { FactoryGirl.create(:venue) }
  before { @sw = site.sitevenues.build(venue_id: venue.id) }
  
  subject { @sw }

  it { should respond_to(:site) }
  its(:site) { should == site }

   it { should respond_to(:venue) }
  its(:venue) { should == venue }

  it { should respond_to(:site_id) }
  it { should respond_to(:venue_id) }

  it { should be_valid }

   describe "when site_id is not present" do
    before { @sw.site_id = nil}
    it { should_not be_valid }
  end

  describe "when venue_id is not present" do
    before { @sw.venue_id = nil}
    it { should_not be_valid }
  end
end
