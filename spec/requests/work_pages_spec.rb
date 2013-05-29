require 'spec_helper'

describe "Work pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) } 
	
	before { sign_in user }

	describe "index page" do

    describe "when there are no categories, subcategories, or works" do
			before { visit works_path }

			it { should have_selector('h1', text: "Works") }
      it { should have_selector('p', text: "This tool has two primary features") }
      
    end

    describe	"when there are categories but no subcategories or works" do
			let!(:wc)  { FactoryGirl.create(:workcategory, user: user) }

    	before { visit works_path }

    	it { should have_selector('h1', text: "Works") }
      it { should have_selector('p', text: "Great start creating categories!") }
      it { should have_selector('a', content: "Create a subcategory") }
      it { should have_selector('a', content: "Create another category") }

      # could add tests for creating a new category successfully and unsuccessfully
      # this is tested in workcategory_pages
      
    end

    describe "when there are categories and subcategories but no works do" do
			let!(:wc)  { FactoryGirl.create(:workcategory, user: user) }
			let!(:wsc)  { FactoryGirl.create(:worksubcategory, workcategory: wc) }

			before { visit works_path }

			it { should have_selector('h1', text: "Works") }
      it { should have_selector('p', text: "Great start creating categories!") }
      it { should_not have_selector('h2', text: "START UPLOADING WORKS!") }
      
    end

    describe "when there are works" do
      let(:work) { FactoryGirl.create(:work, worksubcategory: wsc) }
			before { visit works_path }
      
      it { should have_selector('h1', text: "Works") }
      it { should have_selector('a', content: "Manage Categories") }
      it { should_not have_selector('p', text: "START UPLOADING WORKS!") }
      
    end

  end

  describe  "show page" do
  	let!(:wc)  { FactoryGirl.create(:workcategory, user: user) }
		let!(:wsc)  { FactoryGirl.create(:worksubcategory, workcategory: wc) }
		let(:work) { FactoryGirl.create(:work, worksubcategory: wsc) }

    describe "when there is no activity" do
			before { visit work_path(work) }
	    
	    it { should have_selector('a', text:  "Works") }
	    it { should have_selector('h1', text: work.title) }
      it { should have_selector('a', text: "New Activity") }
    end

    describe "when there are activities" do
      let!(:c)    { FactoryGirl.create(:client, user: user) }
    	let!(:vc)   { FactoryGirl.create(:venuecategory, user: user) }
		  let!(:v)    { FactoryGirl.create(:venue, venuecategory: vc) }

      describe "and piece is not available" do
        let!(:ac_sold)   { FactoryGirl.create(:activitycategory, user: user, name:'Sale', status:'Sold') }
        let!(:a)   { FactoryGirl.create(:activity, activitycategory: ac_sold, work: work, venue: v, client: c, date_start: '2013-01-01', date_end: '2013-01-01') }
        before { visit work_path(work) }
      
        it { should have_selector('a', text:  "Works") }
        it { should have_selector('h1', text: work.title) }
        it { should have_selector('h2', content: "Its Journey") }
        # Add test to make sure each activity is listed. 
      end

      describe "and piece is available" do
        let!(:ac_consignedPreviously)   { FactoryGirl.create(:activitycategory, user: user, name:'Consign', status:'Consigned', final: false) }
        let!(:a)   { FactoryGirl.create(:activity, activitycategory: ac_consignedPreviously, work: work, venue: v, client: c, date_start: '2012-01-01', date_end: '2013-01-01') }
        before { visit work_path(work) }
      
        it { should have_selector('a', text: "New Activity") }
        it { should have_selector('h2', content: "Its Journey") }
      end
    end #/when there are activities
	end
end
