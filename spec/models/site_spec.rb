# == Schema Information
#
# Table name: sites
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  brand             :string(255)
#  tag_line          :string(255)
#  email             :string(255)
#  phone             :string(255)
#  address_street    :string(255)
#  address_city      :string(255)
#  address_state     :string(255)
#  address_zipcode   :string(255)
#  domain            :string(255)
#  blog              :string(255)
#  social_etsy       :string(255)
#  social_googleplus :string(255)
#  social_facebook   :string(255)
#  social_linkedin   :string(255)
#  social_twitter    :string(255)
#  social_pinterest  :string(255)
#  bio_pic           :string(255)
#  bio_text          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe Site do
  before { pending }
  let(:user) { FactoryGirl.create(:user) }
  let(:wc)   { FactoryGirl.create(:workcategory, user: user) }
  let(:wsc)  { FactoryGirl.create(:worksubcategory, workcategory: wc) }
  let(:w)    { FactoryGirl.create(:work, worksubcategory: wsc) }
  let(:vc)   { FactoryGirl.create(:venuecategory) }
  let(:v)    { FactoryGirl.create(:venue, venuecategory: vc) }
  before { @site = user.sites.build(brand: "Art by Julia") }
  
  subject { @site }

  it { should respond_to(:address_city) }
  it { should respond_to(:address_state) }
  it { should respond_to(:address_street) }
  it { should respond_to(:address_zipcode) }
  it { should respond_to(:bio_pic) }
  it { should respond_to(:bio_text) }
  it { should respond_to(:blog) }
  it { should respond_to(:brand) }
  it { should respond_to(:domain) }
  it { should respond_to(:phone) }
  it { should respond_to(:social_etsy) }
  it { should respond_to(:social_googleplus) }
  it { should respond_to(:social_facebook) }
  it { should respond_to(:social_linkedin) }
  it { should respond_to(:social_pinterest) }
  it { should respond_to(:social_twitter) }
  it { should respond_to(:tag_line) }
  it { should respond_to(:user_id) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }

  it { should respond_to(:siteworks) }
  it { should respond_to(:sitevenues) }
  it { should respond_to(:works) }
  it { should respond_to(:venues) }

  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Site.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @site.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank brand" do
    before { @site.brand = " " }
    it { should_not be_valid }
  end

  describe "with brand that is too long" do
    before { @site.brand = "a" * 31 }
    it { should_not be_valid }
  end

  it "should destroy associated siteworks" do
    let!(:sw) { FactoryGirl.create(:sitework, site: @site, work: w) }

    siteworks = @site.siteworks.dup
    @site.destroy

    siteworks.should_not be_empty
    siteworks.each do |sitework|
      Sitework.find_by_id(sitework.id).should be_nil
    end
  end

  it "should destroy associated sitevenues" do
    let!(:sv) { FactoryGirl.create(:sitevenue, site: @site, venue: v) }
    sitevenues = @site.sitevenues.dup
    @site.destroy

    sitevenues.should_not be_empty
    sitevenues.each do |sitevenue|
      Sitevenue.find_by_id(sitevenue.id).should be_nil
    end
  end


end
