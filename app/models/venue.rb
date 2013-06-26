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
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :email, :name, :phone, :site, :venuecategory_id
	
	belongs_to :user
	belongs_to :venuecategory
	has_many :activities
	has_many :sitevenues, dependent: :destroy
  has_many :sites,  :through => :sitevenues


	validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 25 }
  
  default_scope order: 'venues.name'
  scope :not_on_site, lambda { |site| where('not venues.id in (?)', site.venues.collect(&:id).push(0)) }
  
  def venuecategory
		Venuecategory.find_by_id(read_attribute(:venuecategory_id)) || Venuecategory.new(:id => 0, :name => "Uncategorized")
  end

end
