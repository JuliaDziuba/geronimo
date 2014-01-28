require 'spec_helper'

describe "Client pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	
	before { sign_in user }

	describe "index page" do

    describe "when there are no clients" do
      before { visit clients_path }
      it { should have_selector('h1', text: "Clients") }
      it { should have_selector('p', text: "Include") }
    end

    describe "when there are clients" do
      let!(:client) { FactoryGirl.create(:client, user: user) }
			before { visit clients_path }
      
      it { should have_selector('h1', text: "Clients") }
      it { should have_selector('table tbody tr', :count => 1) }
    end

  end

  describe  "show page" do
		let(:client) { FactoryGirl.create(:client, user: user) }

    before { visit client_path(client) }
	    
	  it { should have_selector('a', text:  "Clients") }
	  it { should have_selector('h1', text: client.name) }

    describe "when there are activities" do
    	let(:wc)   { FactoryGirl.create(:workcategory, user: user) }
		  let(:w)    { FactoryGirl.create(:work, workcategory: wc) }
		  let(:vc)   { FactoryGirl.create(:venuecategory) }
		  let(:v)    { FactoryGirl.create(:venue, user: user, venuecategory: vc) }
		  let(:ac)   { FactoryGirl.create(:activitycategory) }
			let!(:a)   { FactoryGirl.create(:activity, user: user, activitycategory: ac, work: w, venue: v, client: client) }
			before { visit client_path(client) }
	    
	   	it { should have_selector('table', :id => "Activities") }
	   	it { should have_selector('table tbody tr', :count => 1) }    
	  end
	end

	describe "new page" do
		before { visit new_client_path }

		it { should have_selector('a', text: "Clients") }
		it { should have_selector('h1', text: "New") }

		let(:create) { "Create Client" }

		 describe "with invalid information" do 
      it "should not create a new client" do
        expect { click_button create }.not_to change(Client, :count) 
      end

      describe "input the resulting page" do
      	before { click_button create }

          it { should have_selector('a', text: "Clients") }
          it { should have_selector('h1', text: "New") }
          it { should have_selector('label', text: "Name *") }
          it { should have_content ("error") }
    	end
    end

		describe "when a client is created" do
			before do 
          fill_in "Name",  with: "Susie Shoe"
        end
        
        it "should create a new client" do
          expect { click_button create }.to change(Client, :count).by(1)
        end

        describe "it should bring users to the clients index" do
          before { click_button create }

          it { should have_selector('h1', text: "Clients") }
          it { should_not have_selector('label', text: "Name *") }
          it { should have_content('Your new client has been created!') }
					it { should have_selector('table tbody tr', :count => 1) }
        end
      end
		end
	end
end
