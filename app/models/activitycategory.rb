# == Schema Information
#
# Table name: activitycategories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  final       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class Activitycategory < ActiveRecord::Base
  attr_accessible :description, :name, :status, :final
  
	has_many :activities

	validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :status, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates_inclusion_of :final, :in => [true, false]
  

	default_scope order: 'activitycategories.name'
  
end
