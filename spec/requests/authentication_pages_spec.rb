require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do

    before { visit signin_path }

    it { should have_selector('h1',    text: full_title('')) }
    it { should have_selector('title', text: full_title('')) }

    describe "with invalid information" do
      before { click_button "Sign in!" }

      it { should have_selector('title', text: full_title('')) }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Sign up!" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('a', text: user.name) }
      it { should have_link('sign out', href: signout_path) }
      it { should_not have_link('Sign in!', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in!"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            should have_selector('h1', text: 'Update')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_link('Sign in!') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user page" do
          before { visit user_path(user) }
          it { should have_link('Sign in!') }
        end
      end

      describe "in the Workcategories controller" do

        describe "submitting to the create action" do
          before { post workcategories_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete workcategory_path(FactoryGirl.create(:workcategory)) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('h1', text: "Update") }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
       # it "should not delete a user" do
       #   expect { delete user_path(user) }.not_to change(User, :count)  
       # end   
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
end