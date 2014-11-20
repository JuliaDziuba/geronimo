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
#  income              :decimal(, )
#  retail              :decimal(, )
#  description         :string(255)
#  share               :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image1_file_name    :string(255)
#  image1_content_type :string(255)
#  image1_file_size    :integer
#  image1_updated_at   :datetime
#  materials           :string(255)
#  quantity            :integer          default(1)
#  dimensions          :string(255)
#


class Work < ActiveRecord::Base
  attr_accessible :creation_date, :description, :dimensions, :expense_hours, :expense_materials, :image1, :retail, :income, :inventory_id, :materials, :quantity, :share, :title, :workcategory_id
	has_attached_file :image1, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "MissingImage_thumb.jpg"

	belongs_to :user
  belongs_to :workcategory
  has_many :activities, through: :activityworks
  has_many :activityworks
  has_many :notes, :as => :notable, dependent: :destroy 
  has_many :actions, :as => :actionable, dependent: :destroy 

	validates :user_id, presence: true
  validates :creation_date, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :inventory_id, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :inventory_id, :scope => :user_id, :case_sensitive => false
  validates :description, length: { maximum: 500 }
  validates :expense_hours, :numericality => {:greater_than_or_equal_to => 0, :allow_nil => true }
  validates :expense_materials, :numericality => { :greater_than_or_equal_to => 0, :allow_nil => true }
  validates :retail, :numericality => { :greater_than_or_equal_to => 0, :allow_nil => true }
  validates :income, :numericality => { :greater_than_or_equal_to => 0, :allow_nil => true }
  validates :quantity, :numericality => { :greater_than_or_equal_to => 0, :allow_nil => true }
#  validates_inclusion_of :share, :in => [true, false]
  validate  :inventory_id_format

  scope :order_creation_date, order: 'works.creation_date DESC'
  scope :order_title, order: 'works.title'
  scope :order_updated_at, order: 'works.updated_at DESC'
  scope :createdBeforeDate, lambda { |date| where('creation_date <= ?', date)}
  scope :shared, lambda { where('works.share') }
  scope :not_shared, lambda { where('NOT works.share') }
  scope :in_category, lambda { |category| where('works.workcategory_id = ?', category.id) }
  scope :available, lambda { where('works.quantity > 0') }
  scope :uncategorized, lambda { where('works.workcategory_id IS NULL') }

  def to_param
    inventory_id
  end

  def availableAtDate(date)
    as = self.activityworks.startingBeforeDate(date).first
    as.nil? || ( !as.activitycategory.final && !as.date_end.nil? && as.date_end < date )

  end

  def current_activity
    if self.availableAtDate(Date.today)
      "Available"
    else
      self.activities.first.activitycategory.status
    end
  end

  private

  def inventory_id_format
    all_valid_characters = inventory_id =~ /^[a-zA-Z0-9_]+$/
    errors.add(:inventory_id, "must contain only letters, digits, or underscores") unless all_valid_characters
  end

  def self.to_csv(records)
    CSV.generate do |csv|
      csv << ["inventory_id", "title", "creation_date", "category", "description", "materials", "dimensions", "quantity", "expense_hours", "expense_materials", "retail", "income", "share", "image1_file_name"]
      records.each do |r|
        csv << [r.inventory_id, r.title, r.creation_date, if r.workcategory.nil? then "" else r.workcategory.name end, r.description, r.materials, r.dimensions, r.quantity, r.expense_hours, r.expense_materials, r.income, r.retail, r.share, r.image1_file_name]
      end
    end
  end
 
end