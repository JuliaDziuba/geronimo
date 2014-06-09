require 'spec_helper'

describe "Venue pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let!(:vc)   { FactoryGirl.create(:venuecategory) }
	let(:w)    { FactoryGirl.create(:work, user: user) }
	let!(:ac_consign) { FactoryGirl.create(:activitycategory, name: 'Consignment', status: 'Consigned', final: false) } 
	let!(:ac_commission) { FactoryGirl.create(:activitycategory, name: 'Commission', status: 'Being created', final: false) } 
	let!(:ac_sale) { FactoryGirl.create(:activitycategory, name: 'Sale', status: 'Sold') }
	let!(:v_default) { FactoryGirl.create(:venue, name: 'My Studio', venuecategory_id: vc.id) }
     
	before { sign_in user }

	describe "index page" do
		
    describe "when there are no venues" do
      before { visit venues_path }
      
      it { should have_selector('h1', text: "Venues") }
      it { should have_content("Include venues you are currently") }
    end

    describe "when there are venues" do
      let!(:v) { FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id) }
      let!(:v_2) { FactoryGirl.create(:venue, user: user, venuecategory_id: vc.id, name:"Second Venue") }
			before { visit venues_path }
      
      it { should have_selector('h1', text: "Venues") }
      it { should have_selector('table tbody tr', :count => 2) }
  	end
  end

  describe  "show page" do
  	let!(:v) { FactoryGirl.create(:venue, user: user , venuecategory_id: vc.id) }
		before { visit venue_path(v) }
    

    it { should have_selector('a', text:  "Venues") }
		it { should have_selector('h1', text: v.name) }
		it { should have_button('Update Venue') }
		it { should have_selector('a', text: 'New') }

		describe "when a venue is updated" do
			let(:update) { "Update Venue" }

			describe "with a name that is too long" do
				before do 
					fill_in "Name",  with: "This name is too too too too too too too too too too too long."
					click_button update
       	end

       	it { should have_content("Name is too long")}
				
				describe "when the name is corrected" do
					before do 
						fill_in "Name",  with: "A Nice Short Name"
						click_button update
       		end 

       		it { should have_content("The venue has been updated!") }
       		it { should have_selector("h1", text: "A Nice Short Name")}
				end
			end

			describe "with valid information" do
			end

		end
    
	  describe "when there are activities to show" do
	  	let!(:a_consign_past)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start: '2013-01-01', date_end: '2013-02-01') }
	  	let!(:a_consign_future)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_consign, work: w, venue: v, date_start: '2023-01-01', date_end: '2023-02-01') }
	  	let!(:a_commission_current)   { FactoryGirl.create(:activity, user: user, activitycategory: ac_commission, work: w, venue: v, date_start: '2013-01-01', date_end: '2023-01-01') }
	  	before { visit venue_path(v) }

	  	it { should have_selector("legend", text: "Activities") }
	  	it { should have_selector("table", id: "Activities") }
	  end

	end

	describe "new page" do
		before { visit new_venue_path }

		it { should have_selector('a', text: "Venues") }
		it { should have_selector('h1', text: "New") }

		let(:create) { "Create Venue" }

		describe "with invalid information" do 
      it "should not create a new venue" do
        expect { click_button create }.not_to change(Venue, :count) 
      end

      describe "input the resulting page" do
      	before { click_button create }

          it { should have_selector('a', text: "Venues") }
          it { should have_selector('h1', text: "New") }
          it { should have_selector('label', text: "Name *") }
          it { should have_content ("error") }
    	end
    end

		describe "when a venue is created" do
			before do 
				select_option("venue_venuecategory_id",2)
	      fill_in "Name",  with: "Awesome Venue"
      end
        
      it "should create a new venue" do
        expect { click_button create }.to change(Venue, :count).by(1)
      end

      describe "it should bring users to the venues index" do
        before do
        	click_button create
        end

        it { should have_selector('h1', text: "Venues") }
        it { should_not have_selector('label', text: "Category *") }
        it { should have_content('Your new venue has been added!') }
				it { should have_selector('table tbody tr', :count => 1) }
      end
		end
	end
end
