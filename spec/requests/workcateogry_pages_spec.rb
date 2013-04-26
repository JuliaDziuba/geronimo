require 'spec_helper'

describe "Worktype pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  #Workcategories index

  describe "index page" do

    # This tests when there are workcategories but we need to test when there are no workcategories yet. 
    before do
    	let!(:wt1) { FactoryGirl.create(:workcategory, user: @user, name: "Banana Slings") }
			let!(:wt2) { FactoryGirl.create(:workcategory, user: @user, name: "Apple Sacks") }
    	visit workcategories_path
    end

    it { should have_selector('h1',    text: 'Manage work types') }
    it { should have_selector('title', text: full_title('Manage work types')) }
		it { should have_content(user.workcategories.count) }
    
    it "should list each work type" do
      user.workcategories.all.each do |workcategory|
        page.should have_selector('li', text: user.workcategory.name)
      end
    end

    # workcategory creation

    describe "workcategory creation" do

      describe "workcategory creation with invalid creation" do
        it "should not create a workcategory" do
         expect { click_button "Create new type" }.not_to change(Worktype, :count)
        end

        describe "error messages" do
          before { click_button "Create new type" }
          it { should have_content('error') } 
        end
      end

      describe "with valid information" do

        before do
          fill_in 'workcategory_name', with: "Carrot Sticks"
          fill_in 'workcategory_description', with: "Sticks of carrots"
        end
        it "should create a workcategory" do
         expect { click_button "Create new type" }.to change(Worktype, :count).by(1)
       end
      end
    end 

    describe "workcategory destruction" do
      before { FactoryGirl.create(:workcategory, user: user) }

      it "should delete a workcategory" do
        expect { click_link "delete" }.to change(Worktype, :count).by(-1)
      end
    end
    # workcategoriesub creation

  end
end
