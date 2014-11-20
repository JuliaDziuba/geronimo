# == Schema Information
#
# Table name: activityworks
#
#  id          :integer          not null, primary key
#  activity_id :integer
#  work_id     :integer
#  income      :decimal(, )
#  retail      :decimal(, )
#  sold        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  quantity    :integer
#

class Activitywork < ActiveRecord::Base
  attr_accessible :activity_id, :work_id, :income, :retail, :quantity, :sold

  belongs_to :activity
	belongs_to :work

  before_validation :set_initial_numerics
  before_validation :set_sales

  validates :activity_id, presence: true
  validates :work_id, presence: true
  validates :income, :numericality => { :greater_than_or_equal_to => 0 }
  validates :retail, :numericality => { :greater_than_or_equal_to => 0 }
  validates :quantity, :numericality => { :greater_than_or_equal_to => 0, only_integer: true }
  validates :sold, :numericality => { :greater_than_or_equal_to => 0, only_integer: true }

  scope :startingBeforeDate, lambda { | date | where('activities.date_start <= ?', date) }
  scope :current_works, lambda { | date | where('activities.date_start <= ? AND (activities.date_end IS NULL OR activities.date_end > ?)', date, date) }
  scope :past_works, lambda { | date | where('NOT activities.date_end IS NULL AND activities.date_end <= ?', date) }
  scope :sold_works, lambda { where('sold > 0') }

  def set_sales
    if self.activity.category_id == Activity::SALE[:id]
      self.sold = self.quantity
    end
  end

  def set_initial_numerics
    if self.id.nil?
      if self.income.nil?
        self.income = self.work.income ||= 0.00
      end
      if self.retail.nil?
        self.retail  = self.work.retail ||= 0.00
      end
      c = Activity::CATEGORY_ID_OBJECT_HASH[self.activity.category_id]
      if c == Activity::SALE
        self.sold = self.quantity
      else
        self.sold = 0
      end
    end
    self
  end

  def self.count_quantity(ws)
    count = 0
    ws.each do | w |
      count = count + w.quantity
    end
    count
  end

  def self.count_sold(ws)
    count = 0
    ws.each do | w |
      count = count + w.sold
    end
    count
  end

  def self.to_csv(records)
    CSV.generate do |csv|
      csv << ["activity", "client", "venue", "work", "income", "retail", "quantity", "sold", "date_start", "date_end"]
      records.each do |r|
        csv << [r.activity.name, r.activity.client.name, r.activity.venue.name, r.work.title, r.income, r.retail, r.quantity, r.sold, r.activity.date_start, r.activity.date_end]
      end
    end
  end
end
