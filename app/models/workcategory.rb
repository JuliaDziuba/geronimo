# == Schema Information
#
# Table name: workcategories
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  name             :string(255)
#  artist_statement :string(1000)
#  parent_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#


class Workcategory < ActiveRecord::Base
  attr_accessible :artist_statement, :name, :parent_id
  
  belongs_to :user
  has_many :works
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 25 }
  validates_uniqueness_of :name, :scope => :user_id, :case_sensitive => false
  validates :artist_statement, length: { maximum: 1000 }

	scope :order_name, order: 'workcategories.name'
	scope :shared_with_public, lambda { joins('INNER JOIN works ON works.workcategory_id = workcategories.id').where('works.share_public = ?', TRUE).uniq }
	scope :parents_of_shared_with_public, lambda { where('(id in (?) AND parent_id is NULL) OR id in (?)', shared_with_public.collect(&:id), shared_with_public.collect(&:parent_id)).uniq }
	scope :parents_only, lambda { where('workcategories.parent_id is NULL') }
	scope :children_only, lambda { where('!(workcategories.parent_id is NULL)') }
	scope :children_of_parent, lambda { |parent| where('workcategories.parent_id = ?', parent.id) }
  scope :excluding, lambda { |category| where('workcategories.id != ?',category.id) }

  def children
		self.user.workcategories.where('workcategories.parent_id = ?', self.id)
	end

  def parent_name
    parent = self.user.workcategories.where('id = ?', self.parent_id).first
    if parent.nil? then "" else parent.name end
  end

	def self.to_csv(records)
    CSV.generate do |csv|
      csv << ["name", "artist_statement", "parent"]
      records.each do |r|
        csv << [r.name, r.artist_statement, r.parent_name]
      end
    end
  end
  
end
