require 'spec_helper'

describe "Venue pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:vc)   { FactoryGirl.create(:venuecategory, user: user) }
	let(:wc)   { FactoryGirl.create(:workcategory, user: user) }
	let(:wsc)  { FactoryGirl.create(:worksubcategory, workcategory: wc) }
	let(:w)    { FactoryGirl.create(:work, worksubcategory: wsc) }
	let!(:ac_consign) { FactoryGirl.create(:activitycategory,  user: user, name: 'Consign', status: 'Consigned') } 
	let!(:ac_commission) { FactoryGirl.create(:activitycategory,  user: user, name: 'Commission', status: 'Being created') } 
	let!(:ac_sale) { FactoryGirl.create(:activitycategory,  user: user, name: 'Sale', status: 'Sold') }
		
		
	
	before { sign_in user }

	describe "index page" do

    describe "when there are no venues" do
      before { visit venues_path }
      
      it { should have_selector('h1', text: "Venues") }
      it { should have_selector('p', text: "Include") }
    end

    describe "when there are venues" do
      let!(:v) { FactoryGirl.create(:venue, venuecategory: vc) }
			before { visit venues_path }
      
      it { should have_selector('h1', text: "Venues") }
      it { should_not have_selector('p', text: "Include") }
    end

  end

  describe  "show page" do
  	let!(:v) { FactoryGirl.create(:venue, venuecategory: vc) }
		before { visit venue_path(v) }
    

    it { should have_selector('a', text:  "Venues") }
	  it { should have_selector('h1', text: v.name) }
    
	  describe "when there are current consignments to show" do
	  	let!(:a) { FactoryGirl.create(:activity, activitycategory: ac_consign, work: w, venue: v, date_start: '2013-01-01', date_end: '2023-01-01') }
			before { visit venue_path(v) }

			it { should have_selector('h2', content: "Works Currently Consigned") }
			it { should_not have_content("Works Sold") }
	  end

	  describe "when there are past consignments, future consignments and current commissions only previous consignments should be shown" do
			let!(:a_consign_past)   { FactoryGirl.create(:activity, activitycategory: ac_consign, work: w, venue: v, date_start: '2013-01-01', date_end: '2013-02-01') }
	  	let!(:a_consign_future)   { FactoryGirl.create(:activity, activitycategory: ac_consign, work: w, venue: v, date_start: '2023-01-01', date_end: '2023-02-01') }
	  	let!(:a_commission_current)   { FactoryGirl.create(:activity, activitycategory: ac_commission, work: w, venue: v, date_start: '2013-01-01', date_end: '2023-01-01') }
	  	before { visit venue_path(v) }

	  	it { should have_selector('h2', content: "Works Previously Consigned") }
	  	it { should_not have_content("Works Currently Consigned") }
	  	it { should_not have_content("Works Sold") }
	  end

	  describe "when there are sales to show" do
	  	let!(:a_sale)   { FactoryGirl.create(:activity, activitycategory: ac_sale, work: w, venue: v, venue: v, date_start: '2013-01-01', date_end: '2013-01-01') }
	  	before { visit venue_path(v) }

	  	it { should have_selector('h2', content: "Works Sold") }
	  end

	end

end
