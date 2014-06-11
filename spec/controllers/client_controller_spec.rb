require 'spec_helper'

describe ClientsController do
  let(:user) { FactoryGirl.create(:user) }

  before { sign_in user }
    
	describe "GET index" do
		let!(:c_b) { FactoryGirl.create(:client, user: user, name: "Baker") }
    let!(:c_a) { FactoryGirl.create(:client, user: user, name: "Apprentice") }
    let!(:c_c) { FactoryGirl.create(:client, user: user, name: "Carpenter") }

    
    it "assigns @clients and orders them by name" do
      c_a.id = 0
      c_b.id = 0
      c_c.id = 0
    	clients = [c_a, c_b, c_c]
    	get :index
    	expect(assigns(:clients)).to eq(clients)
    end
  end

  describe "GET show" do
    let!(:c_a) { FactoryGirl.create(:client, user: user, name: "Apprentice") }
    let!(:a_2) { FactoryGirl.create(:action, actionable_id: c_a.id, actionable_type: "Client", due: "2014-01-02") }
    let!(:a_1) { FactoryGirl.create(:action, actionable_id: c_a.id, actionable_type: "Client", due: "2014-01-01") }
    let!(:n_2) { FactoryGirl.create(:note, notable_id: c_a.id, notable_type: "Client", date: "2014-01-02") }
    let!(:n_1) { FactoryGirl.create(:note, notable_id: c_a.id, notable_type: "Client", date: "2014-01-01") }

    it "assigns @actions and orders them by due desc" do
      actions = [a_2, a_1]
      get :show, id: c_a
      expect(assigns(:actions)).to eq(actions)
    end

    it "assigns @notes and orders them by date desc" do
      notes = [n_2, n_1]
      get :show, id: c_a
      expect(assigns(:notes)).to eq(notes)
    end

    pending("assigns @activities and orders then by start_date desc")
  end

end