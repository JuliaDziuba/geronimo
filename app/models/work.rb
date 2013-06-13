# == Schema Information
#
# Table name: works
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  workcategory_id     :integer
#  inventory_id        :string(255)
#  title               :string(255)
#  creation_date       :date
#  expense_hours       :decimal(, )
#  expense_materials   :decimal(, )
#  income_wholesale    :decimal(, )
#  income_retail       :decimal(, )
#  description         :string(255)
#  dimention1          :decimal(, )
#  dimention2          :decimal(, )
#  dimention_units     :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image1_file_name    :string(255)
#  image1_content_type :string(255)
#  image1_file_size    :integer
#  image1_updated_at   :datetime
#


class Work < ActiveRecord::Base
  attr_accessible :creation_date, :description, :dimention1, :dimention2, :dimention_units, :expense_hours, :expense_materials, :image1, :income_retail, :income_wholesale, :inventory_id, :title, :workcategory_id
	has_attached_file :image1, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

	belongs_to :user, dependent: :destroy
  belongs_to :workcategory
	has_many :activities
	has_many :siteworks, dependent: :destroy
  has_many :sites, :through => :siteworks
  

	validates :user_id, presence: true
  validates :creation_date, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 500 }

  default_scope order: 'works.creation_date DESC'
  scope :not_on_site, lambda { |site| where('not works.id in (?)', site.works.collect(&:id)) }
  scope :available, lambda { joins('left join activities on activities.work_id = works.id').where('activities.id IS NULL') }
  scope :uncategorized, lambda { where('works.? IS NULL', :workcategory_id) }

  def workcategory
    self.user.workcategories.find_by_id(read_attribute(:workcategory_id)) || self.user.workcategories.build(:id => 0, :name => "Uncategorized")
  end

  def available
    as = self.activities
    as.count == 0 || ( !as.first.activitycategory.final && as.first.date_start < Date.today && !as.first.date_end.nil? && as.first.date_end < Date.today )
  end

  def status
  	if self.available
      "Available"
  	else
  		a = self.activities.first
  		s = a.activitycategory.status
  		if a.activitycategory.final # This piece is sold, gifted, donated or recycled
  			s + ' to ' + a.client.name
  		elsif s == 'Consigned' # This piece is currently consigned
  			s + ' to ' + a.venue.name
  		else # This piece has been comissioned and is not yet complete
        s + ' by ' + a.client.name
  		end
  	end
  end
 
end
