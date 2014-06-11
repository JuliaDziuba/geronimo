require 'spec_helper'

describe VenuesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:vc)   { FactoryGirl.create(:venuecategory) }
  let!(:v_b) { FactoryGirl.create(:venue, user: user, name: "Beta", venuecategory_id: vc.id) }
  let!(:v_a) { FactoryGirl.create(:venue, user: user, name: "Alpha", venuecategory_id: vc.id) }
  let!(:v_c) { FactoryGirl.create(:venue, user: user, name: "Carp", venuecategory_id: vc.id) }

  before { sign_in user }


	describe "GET index" do 
    it "assigns @venues and orders them by name" do
    	venues = [v_a, v_b, v_c]
    	get :index
    	expect(assigns(:venues)).to eq(venues)
    end
  end

  describe "GET show" do
    let!(:a_2) { FactoryGirl.create(:action, actionable_id: v_a.id, actionable_type: "Venue", due: "2014-01-02") }
    let!(:a_1) { FactoryGirl.create(:action, actionable_id: v_a.id, actionable_type: "Venue", due: "2014-01-01") }
    let!(:n_2) { FactoryGirl.create(:note, notable_id: v_a.id, notable_type: "Venue", date: "2014-01-02") }
    let!(:n_1) { FactoryGirl.create(:note, notable_id: v_a.id, notable_type: "Venue", date: "2014-01-01") }

    it "assigns @actions and orders them by due desc" do
      actions = [a_2, a_1]
      get :show, id: v_a
      expect(assigns(:actions)).to eq(actions)
    end

    it "assigns @notes and orders them by date desc" do
      notes = [n_2, n_1]
      get :show, id: v_a
      expect(assigns(:notes)).to eq(notes)
    end

    pending("assigns @activities and orders then by start_date desc")

  end
end