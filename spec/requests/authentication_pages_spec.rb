require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do

    before { visit signin_path }

    it { should have_selector('title', text: full_title('')) }
    it { should have_content('one small step for you') }
    it { should have_content('We are working hard for you!') }
    

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
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in!', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_content('one small step for you') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:new_user) { FactoryGirl.create(:user) }
      let!(:existing_user) { FactoryGirl.create(:user, share_with_public: true, share_about: true, share_contact: true, share_purchase: true) }
      let(:new_activitycategory) { FactoryGirl.create(:activitycategory, name: "Sale") }
      let!(:existing_activitycategory) { FactoryGirl.create(:activitycategory, name: "Consignment") }
      let(:new_venuecategory) { FactoryGirl.create(:venuecategory, name: "Galleries") }
      let!(:existing_venuecategory) { FactoryGirl.create(:venuecategory, name: "Studios") }
      
      let(:new_client) { FactoryGirl.create(:client, user: existing_user, name: "New Name") }
      let!(:existing_client) { FactoryGirl.create(:client, user: existing_user) }
      let(:new_workcategory) { FactoryGirl.create(:workcategory, user: existing_user, name: "New Category") }
      let!(:existing_workcategory) { FactoryGirl.create(:workcategory, user: existing_user) }
      let(:new_work) { FactoryGirl.create(:work, user: existing_user) }
      let!(:existing_work) { FactoryGirl.create(:work, user: existing_user) }
      
      let(:new_venue) { FactoryGirl.create(:venue, name: "new_venue", user: existing_user, venuecategory: existing_venuecategory) }
      let!(:existing_venue) { FactoryGirl.create(:venue, user: existing_user, venuecategory: existing_venuecategory) }
      let(:new_activity) { FactoryGirl.create(:activity, user: existing_user, activitycategory: existing_activitycategory, work: existing_work, venue: existing_venue) }
      let!(:existing_activity) { FactoryGirl.create(:activity, user: existing_user, activitycategory: existing_activitycategory, work: existing_work, venue: existing_venue) }
          

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(existing_user)
          fill_in "Email",    with: existing_user.email
          fill_in "Password", with: existing_user.password
          click_button "Sign in!"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            should have_selector('h1', text: 'Maker Profile')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the new page" do
          # is should render page fine
          before { visit new_user_path }
          it { should have_button('Sign up!') }
        end

        describe "submitting to the create action" do
          # is should perform the action
          it "should create a user" do
            expect { put user_path(new_user) }.to change(User, :count)  
          end 
        end

        describe "visiting the show page" do
          # it should redirect to the signin page
          before { visit user_path(existing_user) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visiting the index page" do 
          # it should redirect to the sign in page
          before { visit users_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visting the edit page" do 
          # it should redirect to the sign in page
          before { visit edit_user_path(existing_user) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "submitting to the update action" do
          # it should redirect to the sign in page
          before { put user_path(existing_user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Activity#destroy action" do
          # it should redirect to the sign in page
          before { delete user_path(existing_user) }
            specify { response.should redirect_to(signin_path) }
          it "should not delete a user" do
            expect { delete user_path(existing_user) }.not_to change(User, :count)  
          end      
        end

        describe "visting the public page" do 
          # it should redirect to the sign in page
          before { visit public_user_path(existing_user) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end


        describe "visiting the about page" do
          # it should render the page
          before { visit about_user_path(existing_user) }
          it { should have_content('') }
        end

        describe "visiting the contact page" do
          # it should render the page
          before { visit contact_user_path(existing_user) }
          it { should have_content('') }
        end

        describe "visiting the purchase page" do
          # it should render the page
          before { visit purchase_user_path(existing_user) }
          it { should have_content('') }
        end

      end

      describe "in the Activities controller" do

        # describe "visiting the new page" do end

        describe "submitting to the create action" do
          # is should redirect to the signin page
          before { put activity_path(new_activity) }
          specify { response.should redirect_to(signin_path) } 
        end

        describe "visiting the show page" do
          # it should redirect to the signin page
          before { visit activity_path(existing_activity) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visiting the index page" do 
          # it should redirect to the sign in page
          before { visit activities_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visting the edit page" do 
          # it should redirect to the sign in page
          before { visit edit_activity_path(existing_activity) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "submitting to the update action" do
          # it should redirect to the sign in page
          before { put activity_path(existing_activity) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Activity#destroy action" do
          # it should redirect to the sign in page
          before { delete activity_path(existing_activity) }
            specify { response.should redirect_to(signin_path) }
          it "should not delete a client" do
            expect { delete activity_path(existing_activity) }.not_to change(Activity, :count)  
          end      
        end

      end

      describe "in the ActivityCategories controller" do

        describe "submitting to the create action" do
          pending do
            # is should redirect to the sign in page
            before { put activitycategory_path(new_activitycategory) }
            specify { response.should redirect_to(signin_path) }
          end 
        end

        describe "submitting to the update action" do
          pending do
            # it should redirect to the sign in page
            before { put activitycategory_path(existing_activitycategory) }
            specify { response.should redirect_to(signin_path) }
          end
        end

        describe "submitting a DELETE request to the Activitycategory#destroy action" do
          pending("there is no venuecategory_path currently because these should not be deleted") do
              # it should redirect to the sign in page
            before { delete activitycategory_path(existing_activitycategory) }
              specify { response.should redirect_to(signin_path) }
            it "should not delete a client" do
              expect { delete activitycategory_path(existing_activitycategory) }.not_to change(Activitycategory, :count)  
            end 
          end     
        end

      end

      describe "in the Clients controller" do

        # describe "visiting the new page" do end

        describe "submitting to the create action" do
          # is should redirect to the signin page
          before { put client_path(new_client) }
          specify { response.should redirect_to(signin_path) } 
        end

        describe "visiting the show page" do
          # it should redirect to the signin page
          before { visit client_path(existing_client) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visiting the index page" do 
          # it should redirect to the sign in page
          before { visit clients_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        # describe "visting the edit page" do end

        describe "submitting to the update action" do
          # it should redirect to the sign in page
          before { put client_path(existing_client) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Client#destroy action" do
          # it should redirect to the sign in page
          before { delete client_path(existing_client) }
            specify { response.should redirect_to(signin_path) }
          it "should not delete a client" do
            expect { delete client_path(existing_client) }.not_to change(Client, :count)  
          end      
        end
      end

      describe "in the Sessions controller" do

        describe "visiting the new page" do
          # is should render page fine
          before { visit signin_path }
          it { should have_button('Sign in!') }
        end

        describe "submitting to the create action" do
          # is should perform the action
          pending("not sure how to implement this") do
            it "should create a user" do
              expect { put signin_path(existing_user) }.to redirect_to(user_path(existing_user))  
            end
          end
        end

        describe "submitting the destroy action" do 
          # it should redirect to the sign in page
          pending
        end

      end

      describe "in the Static Pages controller" do

        describe "visiting the home page" do
          # is should render page fine
          before { visit root_path }
          it { should have_button('Subscribe') }
        end

        describe "visiting the help page" do
          # it should redirect to the signin page
          before { visit help_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

      end

      describe "in the Venuecategory controller" do

        describe "submitting to the create action" do
          pending do
            # is should redirect to the sign in page
            before { put venuecategory_path(new_venuecategory) }
            specify { response.should redirect_to(signin_path) } 
          end
        end

        describe "submitting to the update action" do
          pending do
            # it should redirect to the sign in page
            before { put venuecategory_path(existing_venuecategory) }
            specify { response.should redirect_to(signin_path) }
          end
        end

        describe "submitting a DELETE request to the Venuecategory#destroy action" do
          pending("there is no venuecategory_path currently because these should not be deleted") do
            # it should redirect to the sign in page
            before { delete venuecategory_path(existing_venuecategory) }
              specify { response.should redirect_to(signin_path) }
            it "should not delete a venuecatgory" do
              expect { delete venuecategory_path(existing_venuecategory) }.not_to change(Venuecategory, :count)  
            end 
          end     
        end

      end

      describe "in the Venues controller" do

        # describe "visiting the new page" do end

        describe "submitting to the create action" do
          # is should redirect to the signin page
          before { put venue_path(new_venue) }
          specify { response.should redirect_to(signin_path) } 
        end

        describe "visiting the show page" do
          # it should redirect to the signin page
          before { visit venue_path(existing_venue) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visiting the index page" do 
          # it should redirect to the sign in page
          before { visit venues_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        # describe "visting the edit page" do end

        describe "submitting to the update action" do
          # it should redirect to the sign in page
          before { put venue_path(existing_venue) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Works#destroy action" do
          # it should redirect to the sign in page
          before { delete venue_path(existing_venue) }
          specify { response.should redirect_to(signin_path) }  
          it "should not delete a venue" do
            expect { delete venue_path(existing_venue) }.not_to change(Venue, :count)  
          end      
        end


      end

      describe "in the Workcategories controller" do

        # describe "visiting the new page" do end

        describe "submitting to the create action" do
          # is should redirect to the signin page
          before { put workcategory_path(new_workcategory) }
          specify { response.should redirect_to(signin_path) } 
        end

        # describe "visiting the show page" do end

        describe "visiting the index page" do 
          # it should redirect to the sign in page
          before { visit workcategories_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visting the edit page" do 
          # it should redirect to the sign in page
          before { visit edit_workcategory_path(existing_workcategory) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "submitting to the update action" do
          # it should redirect to the sign in page
          before { put workcategory_path(existing_workcategory) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Works#destroy action" do
          # it should redirect to the sign in page
          before { delete workcategory_path(existing_workcategory) }
          specify { response.should redirect_to(signin_path) }   
          it "should not delete a workcategory" do
            expect { delete workcategory_path(existing_workcategory) }.not_to change(Workcategory, :count)  
          end      
        end

      end

      describe "in the Works controller" do

        # describe "visiting the new page" do end

        describe "submitting to the create action" do
          # is should redirect to the signin page
          before { put work_path(new_work) }
          specify { response.should redirect_to(signin_path) } 
        end

        describe "visiting the show page" do
          # it should redirect to the signin page
          before { visit work_path(existing_work) }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        describe "visiting the index page" do 
          # it should redirect to the sign in page
          before { visit works_path }
          it { should have_content('Please sign in.') } 
          it { should have_button('Sign in!') }
        end

        # describe "visting the edit page" do end

        describe "submitting to the update action" do
          # it should redirect to the sign in page
          before { put work_path(existing_work) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Works#destroy action" do
          # it should redirect to the sign in page
          before { delete work_path(existing_work) }  
          specify { response.should redirect_to(signin_path) }   
          it "should not delete a work" do
            expect { delete work_path(existing_work) }.not_to change(Work, :count)  
          end      
        end

      end

    end
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('h1', text: "Maker Profile") }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(signin_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }  
        specify { response.should redirect_to(signin_path) }   
        it "should not delete a user" do
          expect { delete user_path(user) }.not_to change(User, :count)  
        end      
      end
    end
  end
end