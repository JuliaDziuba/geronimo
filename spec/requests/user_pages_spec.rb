require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('title', text: full_title('', 'Sign Up')) }
    it { should have_content('one small step for you') } 
  end #/signup page

  pending ("I need to figure out how to do this with gibbon and the api") do
    describe "signup" do

      before { visit signup_path }

      let(:submit) { "Sign up!" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "should report 7 errors" do
          before { click_button submit }
          it { should have_content('The form contains 7 errors.') }
        end
      end

      describe "with valid information" do
        before do
          fill_in "Username",     with: "RspecTest"
          fill_in "Email",        with: "rspec@example.com"
          fill_in "Password",     with: "password"
          fill_in "Password_confirmation", with: "password"
        end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end
      end
    end #/signup
  end

  describe "with signed in user" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }  

    describe "edit" do
      before { visit edit_user_path(user) }

      describe "page" do
        it { should have_selector('h1',    text: "Maker Profile") }
        it { should have_selector('title', text: full_title('', 'Edit Profile')) }
      end

      describe "with invalid information" do
        before do
          fill_in "New Password", with: "newpassword"
          click_button "Update"
        end

        it { should have_content('error') }
      end

      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          click_link "Update Password"
          fill_in "Business Name",    with: new_name
          fill_in "Email",            with: new_email
          fill_in "New Password",     with: "newpassword"
          fill_in "Again",            with: "newpassword"
          click_button "Update"
        end

        it { should have_selector('title', text: full_title('', 'Dashboard')) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { user.reload.name.should  == new_name }
        specify { user.reload.email.should == new_email }
      end
    end #/edit page

    describe "dashboard page" do
      before { visit user_path(user) }

      it { should have_selector('title', text: full_title('', 'Dashboard')) }
    end #/profile page

    describe "index page" do 
      before { visit users_path}

      it { should have_selector('title', text: full_title('', 'Public Makers'))}      
    end #/index page

  end 

  describe "public page" do
    
    let(:update) { "Update Public Site" }

    describe "when no public site is created" do
      let!(:user_a) { FactoryGirl.create(:user, share_with_public: FALSE, share_about: TRUE) }

      describe "the header" do
        before do
          sign_in user_a
          visit user_path(user_a)
        end

        it { should have_selector('a', text: "Create") }
      end

      describe "the public pages should not be available" do
        specify { user_a.share_with_public.should be_false }

        describe "when the about page is visited" do
          before { visit about_user_path(user_a) }
          it { should have_content("Sorry but")}
        end

        describe "when the contact page is visited" do
          before { visit contact_user_path(user_a) }
          it { should have_content("Sorry but")}
        end

        describe "when the purchase page is visited" do
          before { visit purchase_user_path(user_a) }
          it { should have_content("Sorry but")}
        end
      end

      describe "the public form page" do
        before do
          sign_in user_a
          visit public_user_path(user_a)
        end
        it { should have_content("I'd like a public site") }
        it { should_not have_content("Create an about page") }

        describe "is used to create a site" do
          before do
            check "user_share_with_public"
            click_button update
          end

          it { should have_content('Your public profile has been updated') }          
        end
      end
    end

    describe "when there is a public site created" do
      let!(:user_p) { FactoryGirl.create(:user, share_with_public: TRUE) }
    
      describe "the header" do
        before do
          sign_in user_p
          visit user_path(user_p)
        end

        it { should_not have_selector('a', text: "Create") }
        it { should have_selector('a', text: "Update") }
      end

      describe "the public form page" do
        before do
          sign_in user_p
          visit public_user_path(user_p)
        end
        it { should have_content("I'd like a public site") }
        it { should have_content("Create an about page") }

        it { should have_content("Create a contact page") }
        it { should have_content("Create pages for public works") }
        pending { it { should have_content("Create a purchase page") } }

        describe "with an about page shared" do
          before do
            check "user_share_about"
            click_button update
            visit public_user_path(user_p)
          end
          it { should have_content("Alternate URL") }
        end

        describe "with a contact page shared" do
          before do
            check "user_share_contact"
            click_button update
            visit public_user_path(user_p)
          end
          it { should have_content("Etsy") }
        end

        describe "with works shared" do
          before do
            check "user_share_works"
            click_button update
            visit public_user_path(user_p)
          end
          it { should have_content("There are currently") }
        end

        describe "with a purchase page shared" do
          pending {
            before do
              check "user_share_purchase"
              click_button update
              visit public_user_path(user_p)
            end
            it { should have_content("There is nothing to configure") }
          }
        end
      end
    end
  end #/public page

  describe "about page" do
    
    describe "when the user hasn't shared an about page" do
      let!(:user_p) { FactoryGirl.create(:user, share_with_public: TRUE) }
      before { visit about_user_path(user_p) }
      it { should have_content("Sorry but")}
    end

    describe "when the user has an about page" do
      let!(:user_p_a) { FactoryGirl.create(:user, share_with_public: TRUE, share_about: TRUE) }
      before { visit about_user_path(user_p_a) }
      specify { user_p_a.share_about.should be_true }
      it { should have_content('About') }
    #  it { should have_selector('h2', content: 'About') } 
    end
  end #/about page

  describe "contact page" do
    let!(:user) { FactoryGirl.create(:user) }
    
    describe "when the user hasn't shared a contact page" do
      let!(:user_p) { FactoryGirl.create(:user, share_with_public: TRUE) }
      before { visit contact_user_path(user_p) }
      it { should have_content("Sorry but")}
    end

    describe "when the user has a contact page" do
      let!(:user_p_c) { FactoryGirl.create(:user, share_with_public: TRUE, share_contact: TRUE) }
      before { visit contact_user_path(user_p_c) }
      it { should have_selector('h2', content: 'Contact') } 
    end 
  end #/contact page

  describe "work page" do
    let!(:user) { FactoryGirl.create(:user) }
    pending
  end #/work page

  describe "purchase page" do
    describe "when the user hasn't shared a purchase page" do
      pending
    end

    describe "when the user has a purchase page" do
      pending
    end
  end #/purchase page

end