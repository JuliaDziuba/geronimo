# == Schema Information
#
# Table name: venues
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  venuecategory_id :integer
#  name             :string(255)
#  phone            :integer
#  address_street   :string(255)
#  address_city     :string(255)
#  address_state    :string(255)
#  address_zipcode  :integer
#  email            :string(255)
#  site             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


class Venue < ActiveRecord::Base
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :email, :name, :phone, :site, :share_makers, :share_public, :venuecategory_id
	
	belongs_to :user
	belongs_to :venuecategory
	has_many :activities


	validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 25 }
  validates_inclusion_of :share_makers, :in => [true, false]
  validates_inclusion_of :share_public, :in => [true, false]
  
  default_scope order: 'venues.name'
  scope :shared_with_public, lambda { where('venues.share_public == ?', true) }
  scope :not_shared_with_public, lambda { where('venues.share_public == ?', false) }
  scope :shared_with_makers, lambda { where('venues.share_makers == ?', true) }
  scope :not_shared_with_makers, lambda { where('venues.share_makers == ?', false) }
  
  def venuecategory
		Venuecategory.find_by_id(read_attribute(:venuecategory_id)) || Venuecategory.new(:id => 0, :name => "Uncategorized")
  end

end
