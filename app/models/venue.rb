# == Schema Information
#
# Table name: venues
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  venuecategory_id :integer
#  name             :string(255)
#  munged_name      :string(255)
#  phone            :string(255)
#  address_street   :string(255)
#  address_city     :string(255)
#  address_state    :string(255)
#  address_zipcode  :string(255)
#  email            :string(255)
#  site             :string(255)
#  share_makers     :boolean          default(FALSE)
#  share_public     :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


class Venue < ActiveRecord::Base
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :email, :name, :phone, :site, :share_makers, :share_public, :venuecategory_id
	
	belongs_to :user
	belongs_to :venuecategory
	has_many :activities
  has_many :notes, :as => :notable, dependent: :destroy
  has_many :actions, :as => :actionable, dependent: :destroy
  

  before_save :set_munged_name

	validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :name, :scope => :user_id, :case_sensitive => false
  validate :munged_name_is_unique
  validates :venuecategory_id, presence: true
  validates_inclusion_of :share_makers, :in => [true, false]
  validates_inclusion_of :share_public, :in => [true, false]
  
  default_scope order: 'venues.name'
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

  def venuecategory
		Venuecategory.find_by_id(read_attribute(:venuecategory_id)) || Venuecategory.new(:id => 0, :name => "Uncategorized")
  end

  def current_consignments
    result = []
    activity = Activitycategory.find_by_name('Consignment')
    if !activity.nil?
     result = self.activities.currentActivityCategory(activity.id)
    end
    result
  end

  def past_consignments
    result = []
    activity = Activitycategory.find_by_name('Consignment')
    if !activity.nil?
     result = self.activities.previousActivityCategory(activity.id)
    end
    result
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
  
  def self.to_csv(records)
    CSV.generate do |csv|
      csv << ["name", "category", "phone", "email", "site", "address_street", "address_city", "address_state", "address_zipcode"]
      records.each do |r|
        csv << [r.name, r.venuecategory.name, r.phone, r.email, r.site, r.address_street, r.address_city, r.address_state, r.address_zipcode]
      end
    end
  end

end
