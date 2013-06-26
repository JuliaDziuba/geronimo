require 'spec_helper'
require 'pp'

describe "Workcategory pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  #Workcategories index

  describe "index page" do
      
    describe "when there are no workcategories" do
      before { visit workcategories_path }

      it { should have_selector('h1', text: "Categories") }
      it { should have_selector('p', text: "This tool has two primary features") }
      it { should have_selector('h2', content: 'CREATE A CATEGORY') }

      describe "workcategory creation" do

        describe "workcategory creation with invalid creation" do
          it "should not create a workcategory" do
           expect { click_button "Create Workcategory" }.not_to change(Workcategory, :count)
          end

          describe "error messages" do
            before { click_button "Create Workcategory" }
            it { should have_content('There was a problem') } 
          end
        end

        describe "with valid information" do

          before { fill_in 'workcategory_name', with: "Paintings" }
          
          it "should create a workcategory" do
           expect { click_button "Create Workcategory" }.to change(Workcategory, :count).by(1)
         end
        end
      end

    end

    describe "when there are workcategories" do
    
      let!(:wc1) { FactoryGirl.create(:workcategory, user: user, name: "Banana Slings") }
      let!(:wc2) { FactoryGirl.create(:workcategory, user: user, name: "Apple Sacks") }
      
      before { visit workcategories_path }

      it { should have_selector('h1',    text: 'Categories') }
      
      it "should list each work category" do
        user.workcategories.all.each do |workcategory|
          should have_selector('li', text: workcategory.name)
        end
      end 

      describe "workcategory destruction" do
        let!(:wsc) { FactoryGirl.create(:workcategory, user: user, name: "Apple Child", parent_id: wc2.id) }
        let!(:w) { FactoryGirl.create(:work, user: user, workcategory_id: wc2.id)}
      
        it "should delete a workcategory and remove parent_ids of all children categories and workcategory_ids of all sub works" do
          wc_id = wc2.id
          wc = user.workcategories.find_by_id(wc_id)
          wc.children.should_not be_empty
          wc.works.should_not be_empty
          click_link "Delete"
          user.workcategories.find_by_id(wc_id).should be_nil
          user.workcategories.find_by_parent_id(wc_id).should be_nil
          user.works.find_by_workcategory_id(wc_id).should be_nil
        end

      end
    end # when there are workcategories
  end # index page

end
