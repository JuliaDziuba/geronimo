require 'spec_helper'

describe "Activitycategory pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

	describe "index page" do

    describe "when there are no activitycategories" do
      before { visit activitycategories_path }
      # it { should have_selector('title', text: full_title('New')) }
      it { should have_selector('h1', text: "Activity categories") }
      it { should have_selector('p', text: "Step 1") }
    end

    describe "when there are activitycategories" do
      let(:ac)   { FactoryGirl.create(:activitycategory, user: user, name: "Sale") }
      before { visit activitycategories_path }
      
      # it { should have_selector('title', text: full_title('New')) }
      it { should have_selector('h1', text: "Activity categories") }
      # it { should have_selector('ul', :class => "list") }
    end

  end

  describe  "show page" do
    let(:ac)   { FactoryGirl.create(:activitycategory, user: user, name: "Sale") }
		before { visit activitycategory_path(ac) }

    # it { should have_selector('title', text: full_title('New')) }
    it { should have_selector('a', text:  "Activities") }
    it { should have_selector('h1', text: "Sale") }
	end

	describe "edit page" do
    let(:ac)   { FactoryGirl.create(:activitycategory, user: user, name: "Sale") }
		before { visit edit_activitycategory_path(ac) }

    # it { should have_selector('title', text: full_title('New')) }
    it { should have_selector('a', text:  "Activities") }
    it { should have_selector('h1', text: "Update") }
	end

end
