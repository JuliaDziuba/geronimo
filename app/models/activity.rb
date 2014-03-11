# == Schema Information
#
# Table name: activities
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  activitycategory_id :integer
#  venue_id            :integer
#  client_id           :integer
#  work_id             :integer
#  date_start          :date
#  date_end            :date
#  income              :decimal(, )
#  retail              :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  quantity            :integer          default(1)
#

class Activity < ActiveRecord::Base
  attr_accessible :activitycategory_id, :client_id, :date_end, :date_start, :retail, :income, :venue_id, :work_id

	belongs_to :user
  belongs_to :activitycategory
	belongs_to :venue
	belongs_to :work
	belongs_to :client

  before_validation :set_venue
  after_validation :set_date_end

	validates :user_id, presence: true
  validates :activitycategory_id, presence: true
	validates :work_id, presence: true
  validates :venue_id, presence: true
  validates :date_start, presence: true
  # Add validation that date_end, presence: true if activitycategory.final
  # Add validation that date_end >= date_start

	default_scope order: 'activities.date_start DESC'
  scope :startingBeforeDate, lambda { |date| where('date_start <= ?', date)}
  scope :startingAfterDate, lambda { |date| where('date_start > ?', date)}
  scope :startingBeforeDateExcludingSelf, lambda { |date, id| where('date_start <= ? AND id != ?', date, id)}
  scope :startingAfterDateExcludingSelf, lambda { |date, id| where('date_start > ? AND id != ?', date, id)}
  scope :currentActivityCategory, lambda { |id| where('activitycategory_id = :id AND (date_end IS NULL OR date_end > :date)', { id: id, date: Date.today })  }
  scope :previousActivityCategory, lambda { |id| where('activitycategory_id = :id AND (date_end <= :date)', { id: id, date: Date.today })  }
  scope :currentConsignmentsAtVenueBetweenDates, lambda { |venue, date_start, date_end| where('activities.venue_id = ? AND activities.date_start >= ? AND activities.date_start <= ? AND activitycategory_id = ? AND activities.date_end isNull', venue, date_start, date_end, Activitycategory::COMMISSION[:id]) }
  scope :consignmentsAtVenueBetweenDates, lambda { |venue, date_start, date_end| where('activities.venue_id = ? AND activities.date_start >= ? AND activities.date_start <= ? AND activitycategory_id = ?', venue, date_start, date_end, Activitycategory::COMMISSION[:id]) }
  scope :salesAtVenueBetweenDates, lambda { |venue, date_start, date_end| where('activities.venue_id = ? AND activities.date_start >= ? AND activities.date_start <= ? AND activitycategory_id = ?', venue, date_start, date_end, Activitycategory::SALE[:id]) }
  scope :salesToClientBetweenDates, lambda { |client, date_start, date_end| where('activities.client_id = ? AND activities.date_start >= ? AND activities.date_start <= ? AND activitycategory_id = ?', client, date_start, date_end, Activitycategory::SALE[:id]) }
  scope :sales, where('activities.activitycategory_id = ?', Activitycategory::SALE[:id])
  scope :commissions, where('activities.activitycategory_id = ?', Activitycategory::COMMISSION[:id])
  scope :final, where('activities.activitycategory_id in (?)', Activitycategory::FINAL_ACTIVITIES_IDS)

  def activity_before
    if self.id.nil?
      Work.find_by_id(self.work_id).activities.startingBeforeDate(self.date_start).first
    else
      Work.find_by_id(self.work_id).activities.startingBeforeDateExcludingSelf(self.date_start, self.id).first
    end
  end

  def activity_after
    if self.id.nil?
      Work.find_by_id(self.work_id).activities.startingAfterDate(self.date_start).last
    else
      Work.find_by_id(self.work_id).activities.startingAfterDateExcludingSelf(self.date_start, self.id).last
    end
  end

  def occurs_after_existing_final_activity
    @activity_before_new = self.activity_before
    !@activity_before_new.nil? && Activitycategory.find_by_id(@activity_before_new.activitycategory_id).final
  end

  def is_final_but_occurs_before_existing_activities
    Activitycategory.find_by_id(self.activitycategory_id).final && !self.activity_after.nil?
  end

  def starts_before_existing_activity_ended
    @activity_before_new = self.activity_before
    !@activity_before_new.nil? && (@activity_before_new.date_end.nil? || @activity_before_new.date_end > self.date_start)  
  end

  def ends_after_existing_activity_started
    @activity_after_new = self.activity_after
    !@activity_after_new.nil? && (self.date_end.nil? || self.date_end > @activity_after_new.date_start)
  end

  private

    def set_date_end
      self.date_end = self.date_start if !self.activitycategory.nil? && self.activitycategory.final && self.activitycategory.name != Activitycategory::SALE[:name]
    end

    def set_venue
      self.venue_id = self.user.venues.all.collect(&:id).min() if self.venue_id.nil?
    end

  def self.to_csv(records)
    CSV.generate do |csv|
      csv << ["category", "work", "venue", "client", "date_start", "date_end", "income", "retail"]
      records.each do |r|
        csv << [ r.activitycategory.name, r.work.inventory_id, r.venue.name, if r.client.nil? then "unknown" else r.client.name end, r.date_start, r.date_end, r.income, r.retail]
      end
    end
  end

end
