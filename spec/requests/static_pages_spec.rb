require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'GERONIMO!') }
    it { should have_link('Sign up') }
    it { should have_link('Sign in') }
  end
end


