require 'spec_helper'

describe "Site Pages" do
 	
 	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	  		
	before { sign_in user }

	describe "header when no sites exist" do
		before {visit user_path(user) }

		it { should have_selector('a', text: "Create") }
	end

	describe "header when sites exist" do
		let!(:site) { FactoryGirl.create(:site, user: user) }
		before {visit user_path(user) }

		it { should_not have_selector('a', text: "Create") }
		it { should have_selector('a', text: "View") }
	end

	describe "new page" do

		before { visit new_site_path }

		it { should have_selector('a', text: "Public Site") }
		it { should have_selector('h1', text: "New") }
		it { should have_content('This configures you public site. ') }

		describe "with invalid information entered" do
			it "should not create a site" do
        expect { click_button 'Create Site' }.not_to change(Site, :count)
      end
		end

		describe "with valid information entered" do
			 before do
        fill_in "Brand",         with: "Rspec Test"
      end

      it "should create a user" do
        expect { click_button 'Create Site' }.to change(Site, :count).by(1)
      end
		end

  end #/new page

	describe "show page" do
		let!(:site) { FactoryGirl.create(:site, user: user) }
		
		before { visit site_path(site) }

		it { should have_selector('a', text: "Public Site") }
		it { should have_selector('h1', text: site.brand) }
		it { should have_selector('a', text: "Update") }
	  	

		describe "with bare minimum input" do
			before { visit site_path(site) }
			it { should have_selector('p', text: "The public pages below promote you and your art!") }
	  	it { should_not have_selector('a', text: "Blog") }
	  	it { should_not have_selector('a', text: "Category") }
	  end

	  describe "with blog added to site and works shared" do
	  	pending {
	
	  	before { visit site_path(site) }
			it { should have_selector('a', text: "Blog") }
	  	it { should have_selector('a', text: "Category") }
	  }

	  end

  end #/show page

  describe "edit page" do
  	pending
  end #/edit page

  describe "home page" do
  	pending

  end #/home page

  describe "about page" do
  	let!(:site) { FactoryGirl.create(:site, user: user, bio_text: "This test user is awesome.") }
  	before { visit about_site_path(site) }

  	it { should have_selector('h2', content: 'About') } 
  end #/about page

  describe "contact page" do
		let!(:site) { FactoryGirl.create(:site, user: user) }
  	before { visit contact_site_path(site) }

  	it { should have_selector('h2', content: 'Contact') } 
  end #/contact page


  describe "work page" do
  	pending

  end #/work page
  
end
