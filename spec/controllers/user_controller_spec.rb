require 'spec_helper'

describe UsersController do

	describe "GET index" do
		let!(:u_maker) { FactoryGirl.create(:user, name: "Maker", share_with_public: true, tier: User::MAKER) }
    let!(:u_apprentice_no_works) { FactoryGirl.create(:user, name: "Apprentice with no works", share_with_public: true) }
    let!(:u_apprentice_with_works) { FactoryGirl.create(:user, name: "Apprentice with works", share_with_public: true, share_works: true) }
		let!(:u_master) { FactoryGirl.create(:user, name: "Master", share_with_public: true, tier: User::MASTER) }
    
    it "assigns @users and orders them by tier and shared_works" do
    	users = [u_master, u_maker, u_apprentice_with_works, u_apprentice_no_works]
    	get :index
    	expect(assigns(:users)).to eq(users)
    end


  end

end