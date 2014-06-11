require 'spec_helper'

describe WorksController do
  let(:user) { FactoryGirl.create(:user) }
  let!(:w_b) { FactoryGirl.create(:work, user: user, title: "Beta", creation_date: "2014-01-02") }
  let!(:w_a) { FactoryGirl.create(:work, user: user, title: "Alpha", creation_date: "2014-01-01") }
  let!(:w_c) { FactoryGirl.create(:work, user: user, title: "Carp", creation_date: "2014-01-03") }

  before { sign_in user }

	describe "GET index" do 
    it "assigns @works and orders them by creation date" do
    	works = [w_a, w_b, w_c]
    	get :index
    	expect(assigns(:works)).to eq(works)
    end
  end

  describe "GET show" do
    let!(:a_2) { FactoryGirl.create(:action, actionable_id: w_a.id, actionable_type: "Work", due: "2014-01-02") }
    let!(:a_1) { FactoryGirl.create(:action, actionable_id: w_a.id, actionable_type: "Work", due: "2014-01-01") }
    let!(:n_2) { FactoryGirl.create(:note, notable_id: w_a.id, notable_type: "Work", date: "2014-01-02") }
    let!(:n_1) { FactoryGirl.create(:note, notable_id: w_a.id, notable_type: "Work", date: "2014-01-01") }

    it "assigns @actions and orders them by due desc" do
      actions = [a_2, a_1]
      get :show, id: w_a
      expect(assigns(:actions)).to eq(actions)
    end

    it "assigns @notes and orders them by date desc" do
      notes = [n_2, n_1]
      get :show, id: w_a
      expect(assigns(:notes)).to eq(notes)
    end

    pending("assigns @activities and orders then by start_date desc")

  end
end