include ApplicationHelper
include SessionsHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in!"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_constant do |const|
  match do |owner|
    owner.const_defined?(const)
  end
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in!"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def select_option(id,n)
  option_xpath = "//*[@id='#{id}']/option[#{n}]"
  option = find :xpath, option_xpath
  select option.text, :from => id
end

def select_second_option(id)
  second_option_xpath = "//*[@id='#{id}']/option[2]"
  second_option = find :xpath, second_option_xpath
  select second_option.text, :from => id
end

