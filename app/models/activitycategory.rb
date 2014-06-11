# == Schema Information
#
# Table name: activitycategories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  final       :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class Activitycategory < ActiveRecord::Base
  attr_accessible :description, :name, :status, :final

  SALE = { :name => "Sale", :status => 'Sold', :id => "1", :description => "Sale of a work." }
  COMMISSION = { :name => "Commission", :status => 'Commissioned', :id => "2", :description => "Commission of work started, sale to follow." }
  CONSIGNMENT = { :name => "Consignment", :status => 'Consigned', :id => "3", :description => "Consignment of a work, hoping sale follows." }
  GIFT = { :name => "Gift", :status => 'Gifted', :id => "4", :description => "Gift a work." }
  DONATE = { :name => "Donate", :status => 'Donated', :id => "5", :description => "Donate a work." }
  RECYCLE = { :name => "Recycle", :status => 'Recycled', :id => "6", :description => "Recycle a work to create improved visions." }

  ACTIVITYCATEGORIES_ARRAY = [Activitycategory::SALE, Activitycategory::COMMISSION, Activitycategory::CONSIGNMENT, Activitycategory::GIFT, Activitycategory::DONATE, Activitycategory::RECYCLE]
  FINAL_ACTIVITIES_NAMES = [Activitycategory::SALE[:name], Activitycategory::GIFT[:name], Activitycategory::DONATE[:name], Activitycategory::RECYCLE[:name]]
	FINAL_ACTIVITIES_IDS = [Activitycategory::SALE[:id], Activitycategory::GIFT[:id], Activitycategory::DONATE[:id], Activitycategory::RECYCLE[:id]]
  
  has_many :activities

	validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :status, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates_inclusion_of :final, :in => [true, false]
  
  scope :order_name, order: 'activitycategories.name'
	scope :for_venues, where("name in ('Consignment','Donate','Sale')")
	scope :for_clients, where("name in ('Commission','Gift','Sale')")
  
end
