require 'spec_helper'

describe "Workcategory pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  #Workcategories index

  describe "index page" do
      
    describe "when there are no workcategories" do
      before { visit workcategories_path }

      it { should have_selector('h1', text: "Work categories") }
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

      it { should have_selector('h1',    text: 'Work categories') }
      
      it "should list each work type" do
        user.workcategories.all.each do |workcategory|
          should have_selector('li', text: workcategory.name)
        end
      end 

      describe "workcategory destruction" do
        before { FactoryGirl.create(:workcategory, user: user) }

        it "should delete a workcategory" do
          expect { click_link "Delete" }.to change(Workcategory, :count).by(-1)
        end
      end
    end # when there are workcategories
  end # index page

  describe "show page" do
    let!(:wc) { FactoryGirl.create(:workcategory, user: user) }
      
    before do
      visit workcategory_path(wc)
    end

    it { should have_selector('a', text:  "Work categories") }
    it { should have_selector('a', text:  "edit") }
    it { should have_selector('a', text:  "delete") }
    it { should have_selector('h1', text: wc.name) }
  end

end
