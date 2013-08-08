# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  admin              :boolean
#  share_with_makers  :boolean
#  share_with_public  :boolean
#  share_about        :boolean
#  share_contact      :boolean
#  share_price        :boolean          default(FALSE)
#  share_purchase     :boolean
#  share_works        :boolean
#  username           :string(255)
#  password_digest    :string(255)
#  remember_token     :string(255)
#  name               :string(255)
#  domain             :string(255)
#  tag_line           :string(255)
#  blog               :string(255)
#  about              :string(255)
#  email              :string(255)
#  phone              :string(255)
#  address_street     :string(255)
#  address_city       :string(255)
#  address_state      :string(255)
#  address_zipcode    :string(255)
#  social_etsy        :string(255)
#  social_googleplus  :string(255)
#  social_facebook    :string(255)
#  social_linkedin    :string(255)
#  social_twitter     :string(255)
#  social_pinterest   :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class User < ActiveRecord::Base
  attr_accessible :admin, :email, :password, :password_confirmation, :username, :about, :address_city, :address_state, :address_street, :address_zipcode, :blog, :domain, :email, :image, :name, :phone, :share_with_makers, :share_about, :share_contact, :share_price, :share_purchase, :share_works, :share_with_public, :social_etsy, :social_googleplus, :social_facebook, :social_linkedin, :social_pinterest, :social_twitter, :tag_line
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "MakersMoonIconTransparent.gif"

  has_secure_password
  has_many :workcategories, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :venues, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :questions

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validate  :username_format
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, :confirmation => true, :if => :password_changed?
  validates :name, length: { maximum: 50 }
  validates :about, length: { maximum: 2000 }
  


  def to_param
    username
  end

  def password_changed?
    !self.password.blank? or self.password_digest.blank?
  end

  def name
    read_attribute(:name) || read_attribute(:username)

  end

  def work_current_activities
    activities = []
    works = self.works.all(:include => { :activities => :activitycategory })
    works.each do | work |
      if work.available
        activities.push("Available")
      else
        activities.push(work.activities.first.activitycategory.status)
      end
    end
    activities
  end

  def workcategories_showing_families
    categories = []
    self.workcategories.parents_only.each do |parent|
      categories.push(parent)
      if parent.children.any?
        parent.children.each do |child|
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

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end    

    def username_format
      has_one_letter = username =~ /[a-zA-Z]/
      all_valid_characters = username =~ /^[a-zA-Z0-9_]+$/
      errors.add(:username, "must have at least one letter and contain only letters, digits, or underscores") unless (has_one_letter and all_valid_characters)
    end
end
