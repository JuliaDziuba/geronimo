require 'spec_helper'

describe "Activity pages" do

	subject { page }
	let(:vc)   { FactoryGirl.create(:venuecategory) }
	let(:user) 					{ FactoryGirl.create(:user) }
	let!(:w)    				{ FactoryGirl.create(:work, user: user) }
	let!(:v) 						{ FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id) }
	let!(:v_second) 		{ FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id, name: "Second Venue") }
	let!(:ac_consign) 	{ FactoryGirl.create(:activitycategory, name: "Consignment", status: "Consigned", final: false) }
	let!(:ac_sale) 			{ FactoryGirl.create(:activitycategory, name: "Sale",    status: "Sold", final: true) } 
			
  before { sign_in user }

  describe "new page" do
  	before { visit new_activity_path }

  	describe "when a new activity is created" do
  		let!(:a_consign1) { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start:"2013-01-01", date_end:"2013-02-01") }
			let!(:a_consign2) { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start:"2013-03-01", date_end:"2013-04-01") }
			let!(:a_sale)   	{ FactoryGirl.create(:activity, user: user, activitycategory: ac_sale,    work: w, venue: v, date_start:"2013-06-01") }

			let(:create_activity) { "Create Activity" }

			describe "with invalid information" do
				it "should not create an activity" do
     			expect { click_button create_activity }.not_to change(Activity, :count)
    		end
    		describe "should have an error message" do 
    			before { click_button create_activity }
    			it { should have_content('error') }
    		end
  		end

  		describe "with a final activity before previously entered activities" do 
				before do              
	        select 'Sale',  from: "activity_activitycategory_id"
	        fill_in "Date", with: "2013-01-15"
      		select_second_option("activity_work_id")
	      end

				it "should not create an activity" do
     			expect { click_button create_activity }.not_to change(Activity, :count)
    		end

    		describe "should have a warning message" do 
    			before { click_button create_activity }
    			it { should have_content('The new activity you tried to create is final') }
    		end
  		end

  		describe "with an activity that occurs after an existing final activity" do 
				before do
					select 'Sale',  from: "activity_activitycategory_id"
	        fill_in "Date",        with: "2013-07-01"
      		select_second_option("activity_work_id")
	      end
	      it "should not create an activity" do
     			expect { click_button create_activity }.not_to change(Activity, :count)
    		end
    		describe "should have a warning message" do 
    			before { click_button create_activity }
    			it { should have_content('This work is already') }
    		end
  		end

  		describe "with an activity that starts before an existing one ends" do
  			before do
					select 'Consignment',   from: "activity_activitycategory_id"
	        fill_in "Date",     with: "2013-01-15"
	        fill_in "End Date", with: "2013-01-20"
      		select_second_option("activity_work_id")
	      end
  			it "should create a new activity" do
	        expect { click_button create_activity }.to change(Activity, :count).by(1)
	      end

	      describe "should have a message" do
	      	before { click_button create_activity }
	      	it { should have_content('We updated this previous record to end at the start of this new one.') }
	      end

	      describe "should modify the date_end of the existing record" do
	      	before { click_button create_activity }
	        it { user.activities.find_by_date_start("2013-01-15").date_start.should == user.activities.find_by_date_start("2013-01-01").date_end }
	      end
	  	end

  		describe "with an activity that end after an existing one starts" do
  			before do
					select 'Consignment',  from: "activity_activitycategory_id"
	        fill_in "Date",        with: "2013-01-21"
      		fill_in "End Date", with: "2013-03-10"
      		select_second_option("activity_work_id")
	      end
  			it "should create a activity" do
	        expect { click_button create_activity }.to change(Activity, :count).by(1)
	      end

	      describe "should have a message" do
	      	before { click_button create_activity }
	      	it { should have_content('We set the end of the new record you are creating to this date.') }
	      end

	      describe "should modify the date_end of the new record" do
	      	before { click_button create_activity }
	      	it { user.activities.find_by_date_start("2013-01-21").date_end.should == a_consign2.date_start }
	      end
  		end # with an activity that end after an existing one starts"
  	end
  end

  describe "index page" do

  	describe "when there are no activities" do
  		before { visit activities_path }

			it { should have_selector('h1', text: "Activities") }
  		it { should have_selector('p', text: "Made a sale or donate, gift, or recycle a piece?") }
  	end

  	describe "when there are activities" do
	  	let!(:a_consign1) { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start:"2013-01-01", date_end:"2013-02-01") }
			let!(:a_consign2) { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start:"2013-03-01", date_end:"2013-04-01") }
			let!(:a_sale)   	{ FactoryGirl.create(:activity, user: user, activitycategory: ac_sale,    work: w, venue: v, date_start:"2013-06-01") }
			
			before { visit activities_path }
			
			it { should have_selector('h1', text: "Activities") }
  		it { should have_selector('table', :id => "Activities") }
  		it { should have_selector('table tbody tr', :count => 3) }

  	end

	end 

	describe "show page" do
		let(:w)    { FactoryGirl.create(:work, user: user) }
	  let(:a)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v) }

	  let(:update_activity) { "Update Activity" }

		before { visit activity_path(a) }

    it { should have_selector('a', text:  "Activities") }
    it { should have_selector('h1', text: "Consignment") }

    describe "when the venue of a consignment is changed" do 
			before do
				select_second_option('activity_venue_id')    
				click_button update_activity
      end

  		it { should have_content('The activity was updated!') }
		end
	end

end
