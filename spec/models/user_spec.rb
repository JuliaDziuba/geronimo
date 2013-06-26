# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  admin              :boolean
#  about              :string(255)
#  name               :string(255)
#  email              :string(255)
#  location_city      :string(255)
#  location_state     :string(255)
#  password_digest    :string(255)
#  remember_token     :string(255)
#  username           :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require 'spec_helper'

describe User do

 before do
    @user = User.new(name: "Example User", username: "ExampleUser", email: "user@example.com", about: "A little bit about this user is interesting. But only a little bit.",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:about) }
  it { should respond_to(:location_city) }
  it { should respond_to(:location_state) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:workcategories) }
  it { should respond_to(:works) }
  it { should respond_to(:venues) }
  it { should respond_to(:clients) }
  it { should respond_to(:activities) }
  it { should respond_to(:sites) }
  it { should respond_to(:questions) }

  it { should be_valid }
  it { should_not be_admin }

  # Admin

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  # name tests

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # username tests

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 51 }
    it { should_not be_valid }
  end 

  describe "when username has no characters" do
    before { @user.username = "12345678" }
    it { should_not be_valid }
  end 

  describe "when username has special characters" do
    before { @user.username = "hello!" }
    it { should_not be_valid }
  end 

  # email tests

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  # Password tests

  describe "when password is not present" do
  	before { @user.password = @user.password_confirmation = " " }
  	it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
 		before { @user.password_confirmation = nil }
 		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
 		before { @user.save }
  	let(:found_user) { User.find_by_email(@user.email) }

  	describe "with valid password" do
    	it { should == found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
    	let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    	it { should_not == user_for_invalid_password }
    	specify { user_for_invalid_password.should be_false }
  	end
	end

	describe "with a password that's too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }
  	it { should be_invalid }
	end

  # Remember token tests

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  # About tests

  describe "when about is too long" do
    before { @user.about = "a" * 401 }
    it { should_not be_valid }
  end

  # Workcategories and works

  describe "workcategory, worksubcategory, and work associations" do

    before { @user.save }
    let!(:b_workcategory) do 
      FactoryGirl.create(:workcategory, user: @user, name: "Banana Slings", description: "Slings for bananas")
    end
    let!(:a_workcategory) do
      FactoryGirl.create(:workcategory, user: @user, name: "Apple Sacks", description: "Sacks for apples")
    end
    let!(:work_1) do
      FactoryGirl.create(:work, user: @user, title: "A work", creation_date:"2012-01-01")
    end
    let!(:work_2) do
      FactoryGirl.create(:work, user: @user, title: "Another work", creation_date: "2013-01-01")
    end

    it "should have the right categories in the right order" do
      @user.workcategories.should == [a_workcategory, b_workcategory]
    end

    it "should have the right works in the right order" do
      @user.works.should == [work_2, work_1]
    end

    it "should destroy associated workcategories, and works" do
      workcategories = @user.workcategories.dup
      works = @user.works.dup
      @user.destroy
      workcategories.should_not be_empty
      workcategories.each do |workcategory|
        Workcategory.find_by_id(workcategory.id).should be_nil
      end

      works.should_not be_empty
      works.each do |work|
        Work.find_by_id(work.id).should be_nil
      end

    end 
  end


  # Venuecategories and venues

  describe "venuecategory and venue associations" do

    before { @user.save }
    let!(:vc) do
      FactoryGirl.create(:venuecategory, name: "Stores", description: "Stores in the United States.")
    end
    let!(:b_venue) do
      FactoryGirl.create(:venue, user: @user, venuecategory_id: vc.id, name: "Beauty Store")
    end
    let!(:a_venue) do
      FactoryGirl.create(:venue, user: @user, venuecategory_id: vc.id, name: "Another Store")
    end

    it "should have the right venues in the right order" do
      @user.venues.should == [a_venue, b_venue]
    end

    it "should destroy associated venuecategories and venues" do
      venues = @user.venues.dup
      @user.destroy

      venues.should_not be_empty
      venues.each do |venue|
        Venue.find_by_id(venue.id).should be_nil
      end
    end
  end

  #Activities

  describe "activity associations" do
    
    pending "destroying user should destroy associated activities"
    
  end

  # Clients

  describe "client associations" do

    before { @user.save }
    let!(:b_client) do 
      FactoryGirl.create(:client, user: @user, name: "Susie Deep Pockets")
    end
    let!(:a_client) do 
      FactoryGirl.create(:client, user: @user, name: "Betty Deep Pockets")
    end

    it "should have the right clients in the right order" do
      @user.clients.should == [a_client, b_client]
    end

    it "destroying user should destroy associated clients" do
      clients = @user.clients.dup
      @user.destroy
      clients.should_not be_empty
      clients.each do |client|
        Client.find_by_id(client.id).should be_nil
      end
    end
  end

  # Sites

  describe "site associations" do

    before { @user.save }
    let!(:b_site) do 
      FactoryGirl.create(:site, user: @user, brand: "Paintings by Patty")
    end

    let!(:a_site) do 
      FactoryGirl.create(:site, user: @user, brand: "Jewelry by Jamie")
    end

    it "should have the right types in the right order" do
      @user.sites.should == [a_site, b_site]
    end

    it "should destroy associated sites" do
      sites = @user.sites.dup
      @user.destroy
      sites.should_not be_empty
      sites.each do |site|
        Site.find_by_id(site.id).should be_nil
      end
    end
  end
end
