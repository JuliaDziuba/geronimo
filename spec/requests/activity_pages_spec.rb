require 'spec_helper'

describe "Activity pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:ac)   { FactoryGirl.create(:activitycategory, user: user) }

  before { sign_in user }

  describe "index page" do

  	describe "when there are no activities" do
  		before { visit activities_path }

			it { should have_selector('h1', text: "Activities") }
  		it { should have_selector('p', text: "Step 2") }
  	end

  	describe "when there are activities" do
	  	let(:w)    { FactoryGirl.create(:work, user: user) }
		  let(:v)    { FactoryGirl.create(:venue, user: user) }
			let(:a)   { FactoryGirl.create(:activity, activitycategory: ac, work: w, venue: v) }
			before { visit activities_path }
			
			it { should have_selector('h1', text: "Activities") }
  		# it { should have_selector('table', :id => "Activities") }
  	end

	end

	describe "edit page" do
		let(:w)    { FactoryGirl.create(:work, user: user) }
	  let(:v)    { FactoryGirl.create(:venue, user: user) }
		let(:a)   { FactoryGirl.create(:activity, activitycategory: ac, work: w, venue: v) }

		before { visit edit_activity_path(a) }

    it { should have_selector('a', text:  "Activities") }
    it { should have_selector('h1', text: "Update") }
	end

end
