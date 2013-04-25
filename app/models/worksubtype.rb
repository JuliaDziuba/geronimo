# == Schema Information
#
# Table name: worksubtypes
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  worktype_id :integer
#

class Worksubtype < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :worktype

	validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates :worktype_id, presence: true

	default_scope order: 'worksubtypes.name'
end
