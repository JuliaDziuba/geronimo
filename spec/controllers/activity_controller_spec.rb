require 'spec_helper'

describe ActivitiesController do
  let(:user) { FactoryGirl.create(:user) }
  let!(:ac_a)   { FactoryGirl.create(:activitycategory, name: "Alpha",    status: "AlphaRocks", final: false) } 
  let!(:w_a) { FactoryGirl.create(:work, user: user, title: "Alpha") }
  let(:vc)   { FactoryGirl.create(:venuecategory) }
  let!(:v_a) { FactoryGirl.create(:venue, user: user, name: "Alpha", venuecategory_id: vc.id) }
  let!(:c_a) { FactoryGirl.create(:client, user: user, name: "Alpha") }
    
  before { sign_in user } 

    describe "GET index" do
    let!(:act_2) { FactoryGirl.create(:activity, user: user, activitycategory: ac_a, work: w_a, venue: v_a, date_start:"2012-01-01", date_end:"2012-02-01") }
    let!(:act_1) { FactoryGirl.create(:activity, user: user, activitycategory: ac_a, work: w_a, venue: v_a, date_start:"2011-01-01", date_end:"2011-02-01") }
    let!(:act_3) { FactoryGirl.create(:activity, user: user, activitycategory: ac_a, work: w_a, venue: v_a, date_start:"2013-01-01", date_end:"2013-02-01") }
    
    it "assigns @clients and orders them by name" do
      activities = [act_3, act_2, act_1]
      get :index
      expect(assigns(:activities)).to eq(activities)
    end
  end

  describe "GET new" do
    let!(:ac_b)   { FactoryGirl.create(:activitycategory, name: "Beta", status: "BetaRocks", final: false) }
    let!(:w_b) { FactoryGirl.create(:work, user: user, title: "Beta") }
    let!(:v_b) { FactoryGirl.create(:venue, user: user, name: "Beta", venuecategory_id: vc.id) }
    let!(:c_b) { FactoryGirl.create(:client, user: user, name: "Beta") }
    
    it "assigns @activitycategories and orders them by name" do
      activitycategories = [ac_a, ac_b]
      get :new
      expect(assigns(:activitycategories)).to eq(activitycategories)
    end
    
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

  describe "GET edit" do
    let!(:act_1) { FactoryGirl.create(:activity, user: user, activitycategory: ac_a, work: w_a, venue: v_a, date_start:"2011-01-01", date_end:"2011-02-01") }
    let!(:ac_b)   { FactoryGirl.create(:activitycategory, name: "Beta", status: "BetaRocks", final: false) }
    let!(:w_b) { FactoryGirl.create(:work, user: user, title: "Beta") }
    let!(:v_b) { FactoryGirl.create(:venue, user: user, name: "Beta", venuecategory_id: vc.id) }
    let!(:c_b) { FactoryGirl.create(:client, user: user, name: "Beta") }
    
    it "assigns @activitycategories and orders them by name" do
      activitycategories = [ac_a, ac_b]
      get :edit, id: act_1
      expect(assigns(:activitycategories)).to eq(activitycategories)
    end
    
    it "assigns @works and orders them by title" do
      works = [w_a, w_b]
      get :edit, id: act_1
      expect(assigns(:works)).to eq(works)
    end

    it "assigns @clients and orders them by name" do
      clients = [c_a, c_b]
      get :edit, id: act_1
      expect(assigns(:clients)).to eq(clients)
    end

    it "assigns @venues and orders them by name" do
      venues = [v_a, v_b]
      get :edit, id: act_1
      expect(assigns(:venues)).to eq(venues)
    end
    
  end

  describe "GET show" do
    let!(:act_1) { FactoryGirl.create(:activity, user: user, activitycategory: ac_a, work: w_a, venue: v_a, date_start:"2011-01-01", date_end:"2011-02-01") }
    let!(:ac_b)   { FactoryGirl.create(:activitycategory, name: "Beta", status: "BetaRocks", final: false) }
    let!(:w_b) { FactoryGirl.create(:work, user: user, title: "Beta") }
    let!(:v_b) { FactoryGirl.create(:venue,  user: user, name: "Beta", venuecategory_id: vc.id) }
    let!(:c_b) { FactoryGirl.create(:client,  user: user, name: "Beta") }
    
    it "assigns @activitycategories and orders them by name" do
      activitycategories = [ac_a, ac_b]
      get :show, id: act_1
      expect(assigns(:activitycategories)).to eq(activitycategories)
    end
    
    it "assigns @works and orders them by title" do
      works = [w_a, w_b]
      get :show, id: act_1
      expect(assigns(:works)).to eq(works)
    end

    it "assigns @clients and orders them by name" do
      clients = [c_a, c_b]
      get :show, id: act_1
      expect(assigns(:clients)).to eq(clients)
    end

    it "assigns @venues and orders them by name" do
      venues = [v_a, v_b]
      get :show, id: act_1
      expect(assigns(:venues)).to eq(venues)
    end
    
  end
end