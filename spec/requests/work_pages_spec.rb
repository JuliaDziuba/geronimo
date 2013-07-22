require 'spec_helper'

describe "Work pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	
	before { sign_in user }

	describe "index page" do

    describe "when there are no categories or works" do
			before { visit works_path }

			it { should have_selector('h1', text: "Works") }
      it { should have_selector('p', text: "This tool has two primary features") }
      
    end

    describe	"when there are categories but no works" do
			let!(:wc)  { FactoryGirl.create(:workcategory, user: user) }

    	before { visit works_path }

    	it { should have_selector('h1', text: "Works") }
      it { should have_selector('p', text: "Nice start creating categories.") }
      it { should_not have_selector('h2', text: "START UPLOADING WORKS!") }
      it { should have_selector('a', content: "Create another category") }

      # could add tests for creating a new category successfully and unsuccessfully
      # this is tested in workcategory_pages
      
    end

    describe "when there are works" do
      let(:work) { FactoryGirl.create(:work, user: user) }
			before { visit works_path }
      
      it { should have_selector('h1', text: "Works") }
      it { should_not have_selector('p', text: "START UPLOADING WORKS!") }

      #TODO: cycle through works to make sure they are listed in table
      
    end

  end

  describe  "show page" do
  	let(:work) { FactoryGirl.create(:work, user: user) }

    describe "when there is no activity" do
			before { visit work_path(work) }
	    
	    it { should have_selector('a', text:  "Works") }
	    it { should have_selector('h1', text: work.title) }
      it { should have_selector('a', text: "New Activity") }
    end

    describe "when there are activities" do
      let!(:vc)   { FactoryGirl.create(:venuecategory) }
      let!(:c)    { FactoryGirl.create(:client, user: user) }
    	let!(:v)    { FactoryGirl.create(:venue, user: user , venuecategory_id: vc.id) }

      describe "and piece is not available" do
        let!(:ac_sold)   { FactoryGirl.create(:activitycategory, name:'Sale', status:'Sold') }
        let!(:a)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_sold, work: work, venue: v, client: c, date_start: '2013-01-01', date_end: '2013-01-01') }
        before { visit work_path(work) }
      
        it { should have_selector('a', text:  "Works") }
        it { should have_selector('h1', text: work.title) }
        it { should have_selector('h2', content: "Its Journey") }
        # Add test to make sure each activity is listed. 
      end

      describe "and piece is available" do
        let!(:ac_consignedPreviously)   { FactoryGirl.create(:activitycategory, name:'Consignment', status:'Consigned', final: false) }
        let!(:a)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_consignedPreviously, work: work, venue: v, client: c, date_start: '2012-01-01', date_end: '2013-01-01') }
        before { visit work_path(work) }
      
        it { should have_selector('a', text: "New Activity") }
        it { should have_selector('h2', content: "Its Journey") }
      end
    end #/when there are activities
	end
end
