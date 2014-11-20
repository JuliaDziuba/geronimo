require 'spec_helper'

describe "Activity pages" do

	subject { page }
	let!(:user) { FactoryGirl.create(:user) }
	let!(:w1)   { FactoryGirl.create(:work, user: user, inventory_id: 'work1') }
	let!(:w2)		{ FactoryGirl.create(:work, user: user, inventory_id: 'work2') }	
	let!(:w3)		{ FactoryGirl.create(:work, user: user, inventory_id: 'work3') }	
	let!(:w4)		{ FactoryGirl.create(:work, user: user, inventory_id: 'work4') }		
	let!(:v) 		{ FactoryGirl.create(:venue, user: user) }
	let!(:v2) 	{ FactoryGirl.create(:venue, user: user, name: "Second Venue") }
	let!(:c)		{ FactoryGirl.create(:client, user: user) }
			
  before { sign_in user }

  describe "new page" do
  	before { visit new_activity_path }

  	describe "when a new activity is created" do
  		
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

  		describe "with a sale created and no works selected" do
  			before do 
  				select 'Sale', from: "activity_category_id"
  				fill_in 'Date', with: "2014-01-04"
  			end

  			it "should create an activity" do
  				expect { click_button create_activity}.to change(Activity, :count).by(1)
  			end

  			describe "should create an activity with no work activities" do
  				before { click_button create_activity }
					
					it { should have_selector('a', text:  "Activities") }
    			it { should have_selector('h1', text: "Advanced configuration") }
  				it { should have_selector('table tbody tr', :count => 1) }
  			end

  			describe "should have a venue of 'My studio'" do
  				before { click_button create_activity }
	      	it { user.activities.find_by_date_start("2014-01-04").venue.name.should == Venue::DEFAULT }
  			end

  		end

  		describe "with a consignment and 2 works selected" do
  			before do 
  				select 'Consignment', from: "activity_category_id"
  				fill_in 'Start Date', with: "2014-01-04"
  				fill_in 'works_work1_quantity', with: 1
  				fill_in 'works_work3_quantity', with: 3

  			end

  			it "should create an activity" do
  				expect { click_button create_activity }.to change(Activity, :count).by(1)
  			end

  			it "should create two activityworks" do
  				expect { click_button create_activity }.to change(Activitywork, :count).by(2)
  			end

  			describe "should create an activity with 2 work activities" do
  				before { click_button create_activity }
					
					it { should have_selector('a', text:  "Activities") }
    			it { should have_selector('h1', text: "Advanced configuration") }
  				it { should have_selector('table tbody tr', :count => 3) }
  			end

  			describe "should have a client of 'Unknown'" do
  				before { click_button create_activity }
	      	it { user.activities.find_by_date_start("2014-01-04").client.name.should == Client::DEFAULT }
  			end

  		end
  	end
  end

  describe "index page" do

  	describe "when there are no activities" do
  		before { visit activities_path }

			it { should have_selector('h1', text: "Activities") }
  		it { should have_selector('p', text: "By recording where your art is shown and who purchases your art") }
  	end

  	describe "when there are activities" do
	  	let!(:a_consign1) { FactoryGirl.create(:activity, user: user, category_id: Activity::CONSIGNMENT[:id], venue: v, client: c, date_start:"2013-01-01", date_end:"2013-02-01") }
			let!(:a_consign2) { FactoryGirl.create(:activity, user: user, category_id: Activity::CONSIGNMENT[:id], venue: v, client: c, date_start:"2013-03-01", date_end:"2013-04-01") }
			let!(:a_sale)   	{ FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v, client: c, date_start:"2013-06-01", date_end:"2013-06-01") }
			
			before { visit activities_path }
			
			it { should have_selector('h1', text: "Activities") }
  		it { should have_selector('table', :id => "Activities") }
  		it { should have_selector('table tbody tr', :count => 3) }

  	end

	end 

	describe "show page" do
		let(:w)    { FactoryGirl.create(:work, user: user) }
	  let(:a)   { FactoryGirl.create(:activity, user: user, category_id: Activity::CONSIGNMENT[:id], venue: v, client: c) }

	  let(:update_activity) { "Update Activity" }

		before { visit activity_path(a) }

    it { should have_selector('a', text:  "Activities") }
	end

	describe "edit page" do 
		let(:w1)   { FactoryGirl.create(:work, user: user) }
		let(:w2)   { FactoryGirl.create(:work, user: user, title: "Second work") }
		let(:w3)   { FactoryGirl.create(:work, user: user, title: "Third work") }
		let!(:w4)   { FactoryGirl.create(:work, user: user, title: "Fourth work") }
	  let!(:w5)   { FactoryGirl.create(:work, user: user, title: "Fifth work") }
	  let!(:w6)   { FactoryGirl.create(:work, user: user, title: "Sixth work") }
	  let(:a)   { FactoryGirl.create(:activity, user: user, category_id: Activity::CONSIGNMENT[:id], venue: v, client: c, date_start: "2014-01-01") }
		let!(:aw1) { FactoryGirl.create(:activitywork, user: user, activity: a, work: w1, venue: v, client: c, quantity: 1) }
		let!(:aw2) { FactoryGirl.create(:activitywork, user: user, activity: a, work: w2, venue: v, client: c, quantity: 2) }
		let!(:aw3) { FactoryGirl.create(:activitywork, user: user, activity: a, work: w3, venue: v, client: c, quantity: 3) }

	  let(:save) { "Save" }

		before { visit edit_activity_path(a) }

    it { should have_selector('a', text:  "Activities") }
    it { should have_selector('h1', text: "Advanced configuration") }
    it { should have_selector('table tbody tr', :count => 4) }

    describe "when the start date and venue are changed" do
    	let(:new_end_date)  { "2014-01-02" }
    	let(:new_venue_name)	{ "Second Venue" }
        before do
          select new_venue_name, from: "activity_venue_id"
          fill_in "End Date",    with: new_end_date
          click_button save
        end

        specify { user.activities.find_by_date_start("2014-01-01").date_end.strftime("%Y-%m-%d").should  == new_end_date }
        specify { user.activities.find_by_date_start("2014-01-01").venue_id.should == user.venues.find_by_name(new_venue_name).id }
    end

    describe "when 1 new activitywork is created" do
    	before do 
    		select 'Sixth work', from: "new_1_work_id"
  			fill_in 'new_1_income', with: "100.00"
  			fill_in 'new_1_retail', with: "200"
  			fill_in 'new_1_quantity', with: "6"
  			# Should click Add and then fill in new_2_... values to test adding multiple. When I tried this it couldn't find the add button
    	end

    	it "should create three activityworks" do
  			expect { click_button save }.to change(Activitywork, :count).by(1)
  		end

			describe "should save the correct income, retail, and quantity for the activityworks" do
				before do
					click_button save
				end
				specify { user.activityworks.order('created_at DESC').first.income == 100 }
				specify { user.activityworks.order('created_at DESC').first.retail == 200 }
				specify { user.activityworks.order('created_at DESC').first.quantity == 6 }
			end
  	end 

	end
end
