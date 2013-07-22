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
#  dimention1          :string(255)
#  dimention2          :string(255)
#  dimention_units     :string(255)
#  share_makers        :boolean          default(FALSE)
#  share_public        :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image1_file_name    :string(255)
#  image1_content_type :string(255)
#  image1_file_size    :integer
#  image1_updated_at   :datetime
#


class Work < ActiveRecord::Base
  attr_accessible :creation_date, :description, :dimention1, :dimention2, :dimention_units, :expense_hours, :expense_materials, :image1, :income_retail, :income_wholesale, :inventory_id, :share_makers, :share_public, :title, :workcategory_id
	has_attached_file :image1, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

	belongs_to :user
  belongs_to :workcategory
	has_many :activities
  

	validates :user_id, presence: true
  validates :creation_date, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :inventory_id, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :inventory_id, :scope => :user_id, :case_sensitive => false
  validates :description, length: { maximum: 500 }
  validates_inclusion_of :share_makers, :in => [true, false]
  validates_inclusion_of :share_public, :in => [true, false]
  validate  :inventory_id_format

  default_scope order: 'works.creation_date DESC'
  scope :shared_with_public, lambda { where('works.share_public == ?', true) }
  scope :not_shared_with_public, lambda { where('works.share_public == ?', false) }
  scope :shared_with_makers, lambda { where('works.share_makers == ?', true) }
  scope :not_shared_with_makers, lambda { where('works.share_makers == ?', false) }
  scope :in_category, lambda { |category| where('works.workcategory_id = ?', category.id) }
  scope :available, lambda { joins('left join activities on activities.work_id = works.id').where('activities.id IS NULL') }
  scope :uncategorized, lambda { where('works.workcategory_id IS NULL') }

  def to_param
    inventory_id
  end

  def workcategory
    self.user.workcategories.find_by_id(read_attribute(:workcategory_id)) || self.user.workcategories.build(:id => 0, :name => "Uncategorized")
  end

  def available
    as = self.activities
    as.count == 0 || ( !as.first.activitycategory.final && as.first.date_start < Date.today && !as.first.date_end.nil? && as.first.date_end < Date.today )
  end

  def current_activity
    if self.available
      "Available"
    else
      self.activities.first.activitycategory.status
    end
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

  private
  def inventory_id_format
      all_valid_characters = inventory_id =~ /^[a-zA-Z0-9_]+$/
      errors.add(:inventory_id, "must contain only letters, digits, or underscores") unless all_valid_characters
    end
 
end
