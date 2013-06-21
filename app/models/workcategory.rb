# == Schema Information
#
# Table name: workcategories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  parent_id   :integer
#


class Workcategory < ActiveRecord::Base
  attr_accessible :description, :name, :parent_id
  
  belongs_to :user
  has_many :works
  
	validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 500 }

	default_scope order: 'workcategories.name'

	scope :parents_only, lambda { where('workcategories.? IS NULL', :parent_id) }
	scope :children_only, lambda { |parent| where('workcategories.parent_id = ?', parent.id) }
	scope :excluding, lambda { |category| where('workcategories.id != ?',category.id) }

	def children
		self.user.workcategories.where('workcategories.parent_id = ?', self.id)
	end

	def parent_id
		self.user.workcategories.find_by_id(read_attribute(:parent_id)) || self.user.workcategories.build(:id => 0, :name => "None")
  end

end
