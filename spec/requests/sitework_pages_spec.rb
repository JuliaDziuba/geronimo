require 'spec_helper'

describe "Sitework Pages" do

	subject { page }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:site) { FactoryGirl.create(:site, user: user) }
  let!(:work_1) { FactoryGirl.create(:work, user: user, title: "First work") }
  let!(:work_2) { FactoryGirl.create(:work, user: user, title: "Second work") }
  let!(:work_3) { FactoryGirl.create(:work, user: user, title: "Third work") } 

  let(:create_sitework) { "Add work" }
	
  before { sign_in user }

  describe "index page" do
    before { visit site_siteworks_path(site) }
    it { should have_selector('title', text: full_title('')) }
  	it { should have_selector('h1', content: "Public works") }

	  describe "when there are no siteworks" do
	  	it { should_not have_content("Action") }
	  	it { should have_selector('h2', content: "Add works") }

	  	describe "and work is added to site incorrectly" do
	  		it "should not add a work to the site" do
	  			expect { click_button create_sitework }.not_to change(Sitework, :count)
	  		end

	  		describe "should have a warning message" do 
    			before { click_button create_sitework }
    			it { should have_content('error') }
    		end
	  	end #/and work is added to site incorrectly

	  	describe "and work is added to site" do
	  		before do
					select 'First work',  from: "sitework_work_id"
		    end
		      
      	it "should add a work to the site" do
	  			expect { click_button create_sitework }.to change(Sitework, :count)
	  		end

	  		describe "should have a success message" do 
    			before { click_button create_sitework }
    			it { should have_content('added to your site!') }
    		end

    		describe "should have table of works on site" do
    			before { click_button create_sitework }
					it { should have_selector('th', text: "Action") }
				end
	  	end #/and work is added to site
		end #/when there are no siteworks

		describe "when there are siteworks" do
			before do
				select 'First work',  from: "sitework_work_id"
				click_button create_sitework
		  end
		#	let!(:sw) { FactoryGirl.create(:sitework, site: site, work: work_1) }

			it { should have_selector('th', content: "Action") }
	  	it { should have_selector('h2', content: "Add works") }

			describe "sitework destruction" do
		    
		    it "should delete a sitework" do
		      expect { click_link "Remove #{work_1.title}" }.to change(Sitework, :count).by(-1)
		    end
		  end
		end #/when there are siteworks

		describe "when all works have been added to the site" do
			before do
				select 'First work',  from: "sitework_work_id"
				click_button create_sitework
				select 'Second work',  from: "sitework_work_id"
				click_button create_sitework
				select 'Third work',  from: "sitework_work_id"
				click_button create_sitework
		  end
		#  let!(:sw_1) { FactoryGirl.create(:sitework, site: site, work: work_1) }
		#	let!(:sw_2) { FactoryGirl.create(:sitework, site: site, work: work_2) }
		#	let!(:sw_3) { FactoryGirl.create(:sitework, site: site, work: work_3) }
			
			it { should have_selector('th', text: "Action") }
	  	it { should_not have_content("Add works") }

		end #/when there are siteworks

	end #/index
end
