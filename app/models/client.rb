# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  munged_name     :string(255)
#  email           :string(255)
#  phone           :string(255)
#  address_street  :string(255)
#  address_city    :string(255)
#  address_state   :string(255)
#  address_zipcode :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  site            :string(255)
#  share           :boolean          default(FALSE)
#

class Client < ActiveRecord::Base
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :email, :name, :phone, :share, :site

  DEFAULT = "Unknown"

  belongs_to :user
	has_many :activities
  has_many :activityworks, through: :activities 
  has_many :notes, :as => :notable, dependent: :destroy
  has_many :actions, :as => :actionable, dependent: :destroy
  
	before_save :set_munged_name

	validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :name, :scope => :user_id, :case_sensitive => false
	validate :munged_name_is_unique
  validates_inclusion_of :share, :in => [true, false]
  validate  :full_urls
  
  
  scope :order_name, order: 'clients.name'
  scope :all_known, lambda { where('clients.name != ?', 'Unknown') }
  scope :excluding_current, lambda { | id | where('clients.id != ?', id) }

  def to_param
    munged_name
  end

  def set_munged_name
    self.munged_name = name.parameterize
  end

  def munged_name_is_unique
    return unless errors.blank?
    munged_name_unique = self.user.clients.excluding_current(self.id).find_by_munged_name(name.parameterize).nil?
    errors.add(:name, "is too similar to an existing name and will not result in a unique URL") unless (munged_name_unique)
  end
  
  def default?
    self.name == DEFAULT
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
        csv << [r.name, r.phone, r.email, r.site, r.address_street, r.address_city, r.address_state, r.address_zipcode, r.share]
      end
    end
  end

end