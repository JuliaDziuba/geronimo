require 'spec_helper'

describe "Worktype pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  #Worktypes index

  describe "index page" do

    # This tests when there are worktypes but we need to test when there are no worktypes yet. 
    before do
    	let!(:wt1) { FactoryGirl.create(:worktype, user: user, name: "Banana Slings", description: "Slings for bananas") }
			let!(:wt2) { FactoryGirl.create(:worktype, user: user, name: "Apple Sacks", description: "Sacks for apples") }
    	visit worktypes_path
    end

    it { should have_selector('h1',    text: 'Manage work types') }
    it { should have_selector('title', text: full_title('Manage work types')) }
		it { should have_content(user.worktypes.count) }
    
    it "should list each work type" do
      user.worktypes.all.each do |worktype|
        page.should have_selector('li', text: user.worktype.name)
      end
    end

   end
 end
end
    # worktype creation

    describe "worktype creation" do

      describe "worktype creation with invalid creation" do
        it "should not create a worktype" do
         expect { click_button "Create new type" }.not_to change(Worktype, :count)
        end

        describe "error messages" do
          before { click_button "Create new type" }
          it { should have_content('error') } 
        end
      end

      describe "with valid information" do

        before do
          fill_in 'worktype_name', with: "Carrot Sticks"
          fill_in 'worktype_description', with: "Sticks of carrots"
        end
        it "should create a worktype" do
         expect { click_button "Create new type" }.to change(Worktype, :count).by(1)
       end
      end
     end
    end 
    # worktypesub creation