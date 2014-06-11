require 'spec_helper'

describe ActionsController do
  let(:user) { FactoryGirl.create(:user) }
  
  before { sign_in user }

	describe "GET index" do
	  let!(:a_2) { FactoryGirl.create(:action, actionable_id: user.id, actionable_type: "User", due: "2014-01-02") }
    let!(:a_3) { FactoryGirl.create(:action, actionable_id: user.id, actionable_type: "User", due: "2014-01-03") }
    let!(:a_1) { FactoryGirl.create(:action, actionable_id: user.id, actionable_type: "User", due: "2014-01-01") }
		
    it "assigns @actions and orders them by due" do
    	actions = [a_3, a_2, a_1]
    	get :index
    	expect(assigns(:actions)).to eq(actions)
    end
  end

  describe "GET new" do
    let!(:w_b) { FactoryGirl.create(:work, user: user, title: "Beta") }
    let!(:w_a) { FactoryGirl.create(:work, user: user, title: "Alpha") }
    let(:vc)   { FactoryGirl.create(:venuecategory) }
    let!(:v_b) { FactoryGirl.create(:venue, user: user, name: "Beta", venuecategory_id: vc.id) }
    let!(:v_a) { FactoryGirl.create(:venue, user: user, name: "Alpha", venuecategory_id: vc.id) }
    let!(:c_b) { FactoryGirl.create(:client, user: user, name: "Beta") }
    let!(:c_a) { FactoryGirl.create(:client, user: user, name: "Alpha") }

    before { controller.request.stub referer: 'http://makersmoon.com/maker/tester' }
    it "assigns @works and orders them by title" do
      works = [w_a, w_b]
      get :new
      expect(assigns(:works)).to eq(works)
    end

    it "assigns @clients and orders them by name" do
      clients = [c_a, c_b]
      get :new
      expect(assigns(:clients)).to eq(clients)
    end

    it "assigns @venues and orders them by name" do
      venues = [v_a, v_b]
      get :new
      expect(assigns(:venues)).to eq(venues)
    end
  end
end