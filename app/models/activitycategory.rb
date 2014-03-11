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
  
  SALE = { :name => "Sale", :id => "1" }
  COMMISSION = { :name => "Commission", :id => "2" }
  CONSIGNMENT = { :name => "Consignment", :id => "3" }
  GIFT = { :name => "Gift", :id => "4" }
  DONATE = { :name => "Donate", :id => "5" }
  RECYCLE = { :name => "Recycle", :id => "6" }

  FINAL_ACTIVITIES_NAMES = [Activitycategory::SALE[:name], Activitycategory::GIFT[:name], Activitycategory::DONATE[:name], Activitycategory::RECYCLE[:name]]
	FINAL_ACTIVITIES_IDS = [Activitycategory::SALE[:id], Activitycategory::GIFT[:id], Activitycategory::DONATE[:id], Activitycategory::RECYCLE[:id]]
  
	has_many :activities

	validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :status, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates_inclusion_of :final, :in => [true, false]
  

	default_scope order: 'activitycategories.name'
	scope :for_venues, where("name in ('Consignment','Donate','Sale')")
	scope :for_clients, where("name in ('Commission','Gift','Sale')")
  
end
