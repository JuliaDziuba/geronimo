require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('one small step for you') }
  #  it { should have_link('Sign up') }
  #  it { should have_link('Sign in') }
  	it { should have_content('We are working hard for you!') }
  	it { should have_button('Subscribe') }
  end
end


