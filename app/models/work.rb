# == Schema Information
#
# Table name: works
#
#  id                 :integer          not null, primary key
#  worksubcategory_id :integer
#  inventory_id       :string(255)
#  title              :string(255)
#  creation_date      :date
#  expense_hours      :decimal(, )
#  expense_materials  :decimal(, )
#  income_wholesale   :decimal(, )
#  income_retail      :decimal(, )
#  description        :string(255)
#  dimention1         :decimal(, )
#  dimention2         :decimal(, )
#  dimention_units    :string(255)
#  path_image1        :string(255)
#  path_small_image1  :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Work < ActiveRecord::Base
  attr_accessible :creation_date, :description, :dimention1, :dimention2, :dimention_units, :expense_hours, :expense_materials, :income_retail, :income_wholesale, :inventory_id, :path_image1, :path_small_image1, :title, :worksubcategory_id
	belongs_to :worksubcategory
	belongs_to :workcategory
	belongs_to :user
	has_many :activities
	has_many :siteworks, dependent: :destroy
  has_many :sites, :through => :siteworks
  

	validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 500 }
  validates :worksubcategory_id, presence: true

  scope :not_on_site, lambda { |site| where('not works.id in (?)', site.works.collect(&:id)) }
  
  def status
  	u = self.user
  	as = self.activities
  	if as.count == 0
  		'Available'
  	else
  		a = as.first
  		s = a.activitycategory.status
  		f = a.activitycategory.final
  		if f
  			s + ' to ' + a.client.name
  		elsif a.date_start < Date.today && a.date_end > Date.today
  			if s == 'Consigned'
  				s + ' to ' + a.venue.name
  			elsif s == 'Being created'
  				s + ' by ' + a.client.name
  			end
  		else 
  			'Available'
  		end
  	end
  end

  def available
  	self.status == 'Available'
  end

 
end
