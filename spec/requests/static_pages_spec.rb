require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "home page" do
    before { visit root_path }

    it { should have_content('one small step for you') }
    it { should have_selector('h1', text: 'Take control of your business') }
    it { should have_selector('h1', text: 'Get Started!') }
    it { should have_link('Sign up') }
    it { should have_link('Log in') }
    pending("test signing up a new users.")
  end

  describe "features page" do 
  	before { visit features_path }

  	it { should have_selector('h1', text: 'Features')}
  end

  describe "pricing page" do 
  	before { visit pricing_path }

  	it { should have_selector('h1', text: 'Pricing') }
  	it { should have_selector('h1', text: 'Get started!') }
  	pending("test signing up a new users.")
  end

  describe "makers page" do 
    before { visit users_path }

    it { should have_selector('h2', text: 'Promoted Works') }
  end
end 


