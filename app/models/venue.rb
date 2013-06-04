
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
  scope :not_on_site, lambda { |site| where('not venues.id in (?)', site.venues.collect(&:id)) }
  scope :all_except_storage, lambda { where('venues.name != ?', 'Storage') }

  def venuecategory
		self.user.venuecategories.find_by_id(read_attribute(:venuecategory_id)) || self.user.venuecategories.build(:id => 0, :name => "Uncategorized")
  end

end
