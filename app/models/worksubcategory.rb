# == Schema Information
#
# Table name: worksubcategories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  workcategory_id :integer
#

class Worksubcategory < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :workcategory

	validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates :workcategory_id, presence: true

	default_scope order: 'worksubcategories.name'
end
