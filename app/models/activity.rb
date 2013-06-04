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

	before_validation :set_client
  after_validation :set_date_end

	validates :activitycategory_id, presence: true
	validates :venue_id, presence: true
	validates :work_id, presence: true
  validates :client_id, presence: true
  validates :date_start, presence: true
  # Add validation that date_end, presence: true if activitycategory.final
  # Add validation that date_end >= date_start

	default_scope order: 'activities.date_start DESC'
  scope :currentActivityCategory, lambda { |id| where('activitycategory_id = :id AND (date_end > :date) AND (date_start <= :date)', { id: id, date: Date.today })  }
  scope :previousActivityCategory, lambda { |id| where('activitycategory_id = :id AND (date_end < :date)', { id: id, date: Date.today })  }
  

  private

    def set_date_end
      self.date_end = self.date_start if !self.activitycategory.nil? && self.activitycategory.final 
    end

    def set_client
      self.client_id = 1 if self.client_id.nil?
    end

end
