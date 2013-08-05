require 'spec_helper'

describe "Venue pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let!(:vc)   { FactoryGirl.create(:venuecategory) }
	let(:w)    { FactoryGirl.create(:work, user: user) }
	let!(:ac_consign) { FactoryGirl.create(:activitycategory, name: 'Consignment', status: 'Consigned', final: false) } 
	let!(:ac_commission) { FactoryGirl.create(:activitycategory, name: 'Commission', status: 'Being created', final: false) } 
	let!(:ac_sale) { FactoryGirl.create(:activitycategory, name: 'Sale', status: 'Sold') }
		
		
	
	before { sign_in user }

	describe "index page" do

		let(:create) { "Create Venue" }

    describe "when there are no venues" do
      before { visit venues_path }
      
      it { should have_selector('h1', text: "Venues") }
      it { should have_selector('p', text: "Include") }
      it { should have_content("Include") }
      it { should have_button(create) }

	    describe "with invalid information" do
	      it "should not create a venue" do
	        expect { click_button create }.not_to change(Venue, :count)
	      end
	    end

	    describe "with valid information" do
	      before do
	      	select_option("venue_venuecategory_id",2)
	      	fill_in "Name",  with: "TestVenue"
	      end

	      it "should create a venue" do
	        expect { click_button create }.to change(Venue, :count).by(1)
	      end

	      describe "#The response should result in the table of venues being shown" do
	      	pending
	      end
	    end
    end

    describe "when there are venues" do
      let!(:v) { FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id) }
      let!(:v_2) { FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id, name:"Second Venue") }
			before { visit venues_path }
      
      it { should have_selector('h1', text: "Venues") }
      
      describe "each venue should be shown in table" do
      	pending
      end

      describe "and trying to create a new venue" do
      	before do
      		visit venues_path
      		click_link "new"
      	end

				describe "with invalid information" do
		      it "should not create a venue" do
		        expect { click_button create }.not_to change(Venue, :count)
		      end
		    end

		    describe "with valid information" do
		      before do
		      	select_option("venue_venuecategory_id",2)
	      		fill_in "Name",  with: "TestVenue"
		      end

		      it "should create a venue" do
		        expect { click_button create }.to change(Venue, :count).by(1)
		      end
		    end
		  end
    end

  end

  describe  "show page" do
  	let!(:v) { FactoryGirl.create(:venue, user: user , venuecategory_id: vc.id) }
		before { visit venue_path(v) }
    

    it { should have_selector('a', text:  "Venues") }
		it { should have_selector('h1', text: v.name) }
		it { should have_button('Update Venue') }
		it { should have_button('Create Activity') }

		describe "when a venue is updated" do

			describe "with a name that is too long" do
				pending
				describe "when the name is corrected it should result in an updated vending" do
					pending 
				end
			end

			describe "with valid information" do
			end

		end
    
	  describe "when there are current and future consignments to show" do
	  	let!(:v) { FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id) }
			let!(:a_current) { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start: '2013-01-01', date_end: '2018-01-01') }
			let!(:a_future) { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start: '2018-01-01', date_end: '2023-01-01') }
			before { visit venue_path(v) }

			it { should_not have_content("There are no works currently consigned to this venue.") }
			it { should have_content("There were no works previously consigned to this venue.") }
	  	it { should have_content("There are no sales to this venue yet.") }
	  end

	  describe "when there are past consignments, future consignments and current commissions only consignments should be shown" do
			let!(:a_consign_past)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start: '2013-01-01', date_end: '2013-02-01') }
	  	let!(:a_consign_future)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start: '2023-01-01', date_end: '2023-02-01') }
	  	let!(:a_commission_current)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_commission, work: w, venue: v, date_start: '2013-01-01', date_end: '2023-01-01') }
	  	before { visit venue_path(v) }

	  	it { should_not have_content("There are no works currently consigned to this venue.") }
	  	it { should_not have_content("There were no works previously consigned to this venue.") }
	  	it { should have_content("There are no sales to this venue yet.") }
	  end

	  describe "when there are sales to show" do
	  	let!(:a_sale)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_sale, work: w, venue: v, venue: v, date_start: '2013-01-01', date_end: '2013-01-01') }
	  	before { visit venue_path(v) }

	  	it { should_not have_content("There are no sales to this venue yet.") }

	  end

	end

end
