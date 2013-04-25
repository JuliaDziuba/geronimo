# == Schema Information
#
# Table name: worktypesubs
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  worktype_id :integer
#

class Worktypesub < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :worktype

	validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates :worktype_id, presence: true

	default_scope order: 'worktypesubs.name'
end
