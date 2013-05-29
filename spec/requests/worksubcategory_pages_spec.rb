require 'spec_helper'

describe "Worksubcategory Pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:wc) { FactoryGirl.create(:workcategory, user: user) }
  
  before { sign_in user }

  describe "show page" do
    let!(:wsc) { FactoryGirl.create(:worksubcategory, workcategory: wc) }
    before { visit workcategory_worksubcategory_path(wc, wsc) }

    it { should have_selector('a', text:  "Work categories") }
    it { should have_selector('a', text:  wc.name) }
    it { should have_selector('a', text:  "edit") }
    it { should have_selector('a', text:  "delete") }
    it { should have_selector('h1', text: wsc.name) }

    describe "when there are no works" do
      it { should_not have_selector('h2', content: "WORKS") }
    end

    describe "when there are works" do
      let!(:w) { FactoryGirl.create(:work, worksubcategory: wsc) }
      
      before { visit workcategory_worksubcategory_path(wc, wsc) }
    
      it { should have_selector('h2', content: "WORKS") }
    end

  end
end
