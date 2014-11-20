# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  admin                   :boolean          default(FALSE)
#  share_with_makers       :boolean          default(FALSE)
#  share_with_public       :boolean          default(FALSE)
#  share_about             :boolean          default(FALSE)
#  share_contact           :boolean          default(FALSE)
#  share_works_price       :boolean          default(FALSE)
#  share_purchase          :boolean          default(FALSE)
#  share_works             :boolean          default(FALSE)
#  username                :string(255)
#  password_digest         :string(255)
#  remember_token          :string(255)
#  name                    :string(255)
#  domain                  :string(255)
#  tag_line                :string(255)
#  blog                    :string(255)
#  email                   :string(255)
#  phone                   :string(255)
#  address_street          :string(255)
#  address_city            :string(255)
#  address_state           :string(255)
#  address_zipcode         :string(255)
#  social_etsy             :string(255)
#  social_googleplus       :string(255)
#  social_facebook         :string(255)
#  social_linkedin         :string(255)
#  social_twitter          :string(255)
#  social_pinterest        :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :integer
#  image_updated_at        :datetime
#  tier                    :string(255)
#  share_works_status      :boolean          default(TRUE)
#  share_works_materials   :boolean          default(TRUE)
#  share_works_dimensions  :boolean          default(TRUE)
#  share_works_description :boolean          default(TRUE)
#  bio_id                  :integer
#  statement_id            :integer
#


class User < ActiveRecord::Base
  attr_accessible :admin, :email, :password, :password_confirmation, :username, :bio_id, :statement_id, :address_city, :address_state, :address_street, :address_zipcode, :blog, :domain, :email, :image, :name, :phone, :share_with_makers, :share_about, :share_contact, :share_purchase, :share_works, :share_works_price, :share_works_status, :share_works_materials, :share_works_dimensions, :share_works_description, :share_with_public, :social_etsy, :social_googleplus, :social_facebook, :social_linkedin, :social_pinterest, :social_twitter, :tag_line, :tier
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "MakersMoonIconTransparent.gif"

  # There are three types of Users listed as constants below. Their arrays are [typeName, works limit, clients limit, venues limit].
  APPRENTICE = "apprentice"
  MAKER = "maker"
  MASTER = "master"
  TIER_LIMITS = {
    User::APPRENTICE => { "works" => 10, "clients" => 5, "venues" => 2 },
    User::MAKER => { "works" => 100, "clients" => nil, "venues" => nil },
    User::MASTER => { "works" => nil, "clients" => nil, "venues" => nil } 
  }

  has_secure_password
  has_many :workcategories, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :venues, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :activityworks, through: :activities
  has_many :comments, dependent: :destroy
  has_many :notes, :as => :notable, dependent: :destroy
  has_many :actions, :as => :actionable, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :set_tier
  before_save :create_remember_token

  after_create :create_default_consumers

  validate  :full_urls
  validate  :username_format
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, :confirmation => true, :if => :password_changed?
  validates :name, length: { maximum: 50 }
  
  scope :order_tier, order: 'users.tier DESC'
  scope :order_share_works, order: 'users.share_works DESC'
  scope :shared_publicly, where('users.share_with_public')  

  def to_param
    username
  end

  def password_changed?
    !self.password.blank? or self.password_digest.blank?
  end

  def name
    brandname = read_attribute(:name)
    brandname = read_attribute(:username) if brandname.blank?
    brandname
  end

  def tier
    read_attribute(:tier) || User::APPRENTICE
  end

  def limitReached?
    tier = current_user.tier
    workLimit = User::TIER_LIMITS[tier]["works"]
    clientLimit = User::TIER_LIMITS[tier]["clients"]
    venueLimit = User::TIER_LIMITS[tier]["venues"]
    current_user.works.all.count == workLimit || current_user.clients.all.count == clientLimit || current_user.venues.all.count == venueLimit    
  end

  def work_activities_at_time(date)
    activities = []
    works = self.works.createdBeforeDate(date).all(:include => { :activities => :activitycategory })
    works.each do | work |
      if work.availableAtDate(date)
        activities.push("Available")
      else
        activities.push(work.activities.startingBeforeDate(date).first.activitycategory.status)
      end
    end
    activities
  end


  def work_current_activities
    activities = []
    works = self.works.all(:include => { :activities => :activitycategory })
    works.each do | work |
      if work.availableAtDate(Date.today)
        activities.push("Available")
      else
        activities.push(work.activities.first.activitycategory.status)
      end
    end
    activities
  end

  def workcategories_showing_families
    categories = []
    self.workcategories.parents_only.order_name.each do |parent|
      categories.push(parent)
      if parent.children.any?
        parent.children.order_name.each do |child|
          child.name = parent.name + " > " + child.name
          categories.push(child)
        end
      end
    end
    categories
  end

  def social_links_present?
    self.social_etsy || self.social_googleplus || self.social_facebook || self.social_linkedin || self.social_pinterest || self.social_twitter
  end

  private

    def create_default_consumers
      self.venues.create!(name: Venue::DEFAULT)
      self.clients.create!(name: Client::DEFAULT)
    end

    def set_tier
      self.tier = read_attribute(:tier) || User::APPRENTICE
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end    

    def username_format
      has_one_letter = username =~ /[a-zA-Z]/
      all_valid_characters = username =~ /^[a-zA-Z0-9_]+$/
      errors.add(:username, "must have at least one letter and contain only letters, digits, or underscores") unless (has_one_letter and all_valid_characters)
    end

    def full_urls
      blog_url_not_valid = ! (blog.blank? or blog.include? 'http://' or blog.include? 'https://')
      domain_url_not_valid = ! (domain.blank? or domain.include? "http://" or domain.include? "https://")
      social_etsy_url_not_valid = ! (social_etsy.blank? or social_etsy.include? "http://" or social_etsy.include? "https://")
      social_googleplus_url_not_valid = ! (social_googleplus.blank? or social_googleplus.include? "http://" or social_googleplus.include? "https://")
      social_facebook_url_not_valid = ! (social_facebook.blank? or social_facebook.include? "http://" or social_facebook.include? "https://")
      social_linkedin_url_not_valid = ! (social_linkedin.blank? or social_linkedin.include? "http://" or social_linkedin.include? "https://")
      social_twitter_url_not_valid = ! (social_twitter.blank? or social_twitter.include? "http://" or social_twitter.include? "https://")
      social_pinterest_url_not_valid = ! (social_pinterest.blank? or social_pinterest.include? "http://" or social_pinterest.include? "https://")
      
      valid = true
      if blog_url_not_valid
        errors.add(:blog, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if domain_url_not_valid
        errors.add(:domain, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if social_etsy_url_not_valid
        errors.add(:social_etsy, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if social_googleplus_url_not_valid
        errors.add(:social_googleplus, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if social_facebook_url_not_valid
        errors.add(:social_facebook, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if social_linkedin_url_not_valid
        errors.add(:social_linkedin, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if social_twitter_url_not_valid
        errors.add(:social_twitter, "must be the full URL starting with http:// or https://")
        valid = false
      end
      if social_pinterest_url_not_valid
        errors.add(:social_pinterest, "must be the full URL starting with http:// or https://")
        valid = false
      end
      valid
    end

    def self.to_csv(r)
    CSV.generate do |csv|
      csv << ["username", "name", "domain", "tag_line", "blog", "phone", "email", "address_street", "address_city", "address_state", "address_zipcode", "social_etsy", "social_googleplus", "social_facebook", "social_linkedin", "social_twitter", "social_pinterest", "image_file"]
      csv << [r.username, r.name, r.domain, r.tag_line, r.blog, r.phone, r.email, r.address_street, r.address_city, r.address_state, r.address_zipcode, r.social_etsy, r.social_googleplus, r.social_facebook, r.social_linkedin, r.social_twitter, r.social_pinterest, r.image_file_name]
    end
  end

end