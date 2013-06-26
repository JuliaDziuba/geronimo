require 'spec_helper'

describe "Client pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	
	before { sign_in user }

	describe "index page" do

    describe "when there are no clients" do
      before { visit clients_path }
      # it { should have_selector('title', text: full_title('New')) }
      it { should have_selector('h1', text: "Clients") }
      it { should have_selector('p', text: "Include") }
    end

    describe "when there are clients" do
      let(:client) { FactoryGirl.create(:client, user: user) }
			before { visit clients_path }
      
      # it { should have_selector('title', text: full_title('New')) }
      it { should have_selector('h1', text: "Clients") }
      # it { should have_selector('ul', :class => "list") }
    end

  end

  describe  "show page" do
		let(:client) { FactoryGirl.create(:client, user: user) }

    describe "when there is no activity" do
			before { visit client_path(client) }
	    
	    # it { should have_selector('title', text: full_title('New')) }
	    it { should have_selector('a', text:  "Clients") }
	    it { should have_selector('h1', text: client.name) }
    end

    describe "when there are activities" do
    	let(:wc)   { FactoryGirl.create(:workcategory, user: user) }
		  let(:wsc)  { FactoryGirl.create(:worksubcategory, workcategory: wc) }
		  let(:w)    { FactoryGirl.create(:work, worksubcategory: wsc) }
		  let(:vc)   { FactoryGirl.create(:venuecategory) }
		  let(:v)    { FactoryGirl.create(:venue, user: user, venuecategory: vc) }
		  let(:ac)   { FactoryGirl.create(:activitycategory) }
			let(:a)   { FactoryGirl.create(:activity, user: user, activitycategory: ac, work: w, venue: v, client: client) }
			before { visit client_path(client) }
	    
	    # it { should have_selector('title', text: full_title('New')) }
	    it { should have_selector('a', text:  "Clients") }
	    it { should have_selector('h1', text: client.name) }
	    # it { should have_selector('table', :id => "Activities") }
    end

	end

end
