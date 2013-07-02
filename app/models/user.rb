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

class User < ActiveRecord::Base
  attr_accessible :about, :admin, :name, :email, :image, :location_city, :location_state, :password, :password_confirmation, :username
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "MakersMoonIconTransparent.gif"


  has_secure_password
  has_many :workcategories, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :venues, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :questions

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :about, length: { maximum: 400 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validate  :username_format
  
  def to_param
    username
  end

  def work_current_activities
    activities = []
    self.works.each do | work |
      activities.push(work.current_activity)
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
