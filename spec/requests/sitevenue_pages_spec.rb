require 'spec_helper'

describe "Sitevenue Pages" do

	subject { page }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:site) { FactoryGirl.create(:site, user: user) }
  let!(:venue_1) { FactoryGirl.create(:venue, user: user, name: "First venue") }
  let!(:venue_2) { FactoryGirl.create(:venue, user: user, name: "Second venue") }
  let!(:venue_3) { FactoryGirl.create(:venue, user: user, name: "Third venue") } 

  let(:create_sitevenue) { "Add venue" }
	
  before { sign_in user }

  describe "index page" do
    before { visit site_sitevenues_path(site) }
    it { should have_selector('title', text: full_title('')) }
  	it { should have_selector('h1', content: "Public venues") }

	  describe "when there are no sitevenues" do
	  	it { should_not have_content("Action") }
	  	it { should have_selector('h2', content: "Add venues") }

	  	describe "and venue is added to site incorrectly" do
	  		it "should not add a venue to the site" do
	  			expect { click_button create_sitevenue }.not_to change(Sitevenue, :count)
	  		end

	  		describe "should have a warning message" do 
    			before { click_button create_sitevenue }
    			it { should have_content('error') }
    		end
	  	end #/and venue is added to site incorrectly

	  	describe "and venue is added to site" do
	  		before do
					select 'First venue',  from: "sitevenue_venue_id"
		    end
		      
      	it "should add a venue to the site" do
	  			expect { click_button create_sitevenue }.to change(Sitevenue, :count)
	  		end

	  		describe "should have a success message" do 
    			before { click_button create_sitevenue }
    			it { should have_content('added to your site!') }
    		end

    		describe "should have table of venues on site" do
    			before { click_button create_sitevenue }
					it { should have_selector('th', text: "Action") }
				end
	  	end #/and venue is added to site
		end #/when there are no sitevenues

		describe "when there are sitevenues" do
			before do
				select 'First venue',  from: "sitevenue_venue_id"
				click_button create_sitevenue
		  end
		#	let!(:sw) { FactoryGirl.create(:sitevenue, site: site, venue: venue_1) }

			it { should have_selector('th', content: "Action") }
	  	it { should have_selector('h2', content: "Add venues") }

			describe "sitevenue destruction" do
		    
		    it "should delete a sitevenue" do
		      expect { click_link "Remove #{venue_1.name}" }.to change(Sitevenue, :count).by(-1)
		    end
		  end
		end #/when there are sitevenues

		describe "when all venues have been added to the site" do
			before do
				select 'First venue',  from: "sitevenue_venue_id"
				click_button create_sitevenue
				select 'Second venue',  from: "sitevenue_venue_id"
				click_button create_sitevenue
				select 'Third venue',  from: "sitevenue_venue_id"
				click_button create_sitevenue
		  end
		#  let!(:sw_1) { FactoryGirl.create(:sitevenue, site: site, venue: venue_1) }
		#	let!(:sw_2) { FactoryGirl.create(:sitevenue, site: site, venue: venue_2) }
		#	let!(:sw_3) { FactoryGirl.create(:sitevenue, site: site, venue: venue_3) }
			
			it { should have_selector('th', text: "Action") }
	  	it { should_not have_content("Add venues") }

		end #/when there are sitevenues

	end #/index
end
