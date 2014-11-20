# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  name            :string(255)
#  munged_name     :string(255)
#  phone           :string(255)
#  address_street  :string(255)
#  address_city    :string(255)
#  address_state   :string(255)
#  address_zipcode :string(255)
#  email           :string(255)
#  site            :string(255)
#  share           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Venue < ActiveRecord::Base
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :email, :name, :phone, :site, :share_makers, :share_public, :venuecategory_id
  
  DEFAULT = "My studio"

  belongs_to :user
  has_many :activities
  has_many :activityworks, through: :activities 
  has_many :notes, :as => :notable, dependent: :destroy
  has_many :actions, :as => :actionable, dependent: :destroy
  

  before_save :set_munged_name

  validate  :full_urls
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :name, :scope => :user_id, :case_sensitive => false
  validate :munged_name_is_unique
  validates_inclusion_of :share, :in => [true, false]
  
  scope :order_name, order: 'venues.name'
  scope :shared_with_public, lambda { where('venues.share_public == ?', true) }
  scope :not_shared_with_public, lambda { where('venues.share_public == ?', false) }
  scope :shared_with_makers, lambda { where('venues.share_makers == ?', true) }
  scope :not_shared_with_makers, lambda { where('venues.share_makers == ?', false) }
  scope :excluding_current, lambda { | id | where('venues.id != ?', id) }
  
  def to_param
    munged_name
  end

  def set_munged_name
    if ! self.name.blank?
      self.munged_name = self.name.parameterize 
    end
  end

  def default?
    self.name == DEFAULT
  end

  def current_works_quantity
    aws = self.activityworks.current_works(Date.today())
    Activitywork.count_quantity(aws) - Activitywork.count_sold(aws)
  end

  def past_works_quantity
     Activitywork.count_quantity(self.activityworks.past_works(Date.today()))
  end

  def sold_works_quantity
     Activitywork.count_sold(self.activityworks.sold_works)
  end

  def sales
    result = []
    activity = Activitycategory.find_by_name('Sale')
    if !activity.nil?
     result = self.activities.previousActivityCategory(activity.id)
    end
    result
  end

  def munged_name_is_unique
    return unless errors.blank?
    munged_name_unique = self.user.venues.excluding_current(self.id).find_by_munged_name(name.parameterize).nil?
    errors.add(:name, "is too similar to an existing name and will not result in a unique URL") unless (munged_name_unique)
  end

  def full_urls
    site_url_not_valid = ! (site.blank? or site.include? 'http://' or site.include? 'https://')
                  
    valid = true
    if site_url_not_valid
      errors.add(:site, "must be the full URL starting with http:// or https://")
      valid = false
    end
    valid
  end
  
  def self.to_csv(records)
    CSV.generate do |csv|
      csv << ["name", "phone", "email", "site", "address_street", "address_city", "address_state", "address_zipcode", "share"]
      records.each do |r|
        csv << [r.name,  r.phone, r.email, r.site, r.address_street, r.address_city, r.address_state, r.address_zipcode, r.share]
      end
    end
  end

end
