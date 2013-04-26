# == Schema Information
#
# Table name: worktypes
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#

class Workcategory < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :user
  has_many :worksubcategories, dependent: :destroy

	validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates :user_id, presence: true

	default_scope order: 'workcategories.name'
end
