# == Schema Information
#
# Table name: activities
#
#  id                  :integer          not null, primary key
#  activitycategory_id :integer
#  venue_id            :integer
#  client_id           :integer
#  work_id             :integer
#  date_start          :date
#  date_end            :date
#  income_wholesale    :decimal(, )
#  income_retail       :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Activity < ActiveRecord::Base
  attr_accessible :activitycategory_id, :client_id, :date_end, :date_start, :income_retail, :income_wholesale, :venue_id, :work_id

	belongs_to :activitycategory
	belongs_to :venue
	belongs_to :work
	belongs_to :client
	belongs_to :user

	validates :activitycategory_id, presence: true
	validates :venue_id, presence: true
	validates :work_id, presence: true

end
