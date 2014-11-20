# == Schema Information
#
# Table name: activities
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  date_start            :date
#  date_end              :date
#  subject               :text
#  maker                 :string(255)
#  maker_medium          :string(255)
#  maker_phone           :string(255)
#  maker_email           :string(255)
#  maker_site            :string(255)
#  maker_address_street  :string(255)
#  maker_address_city    :string(255)
#  maker_address_state   :string(255)
#  maker_address_zipcode :string(255)
#  include_image         :boolean          default(FALSE)
#  include_title         :boolean          default(FALSE)
#  include_inventory_id  :boolean          default(FALSE)
#  include_creation_date :boolean          default(FALSE)
#  include_quantity      :boolean          default(FALSE)
#  include_dimensions    :boolean          default(FALSE)
#  include_materials     :boolean          default(FALSE)
#  include_description   :boolean          default(FALSE)
#  include_income        :boolean          default(FALSE)
#  include_retail        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  client_id             :integer
#  venue_id              :integer
#  category_id           :integer
#

class Activity < ActiveRecord::Base
  attr_accessible :category_id, :client_id, :venue_id, :date_start, :date_end, :subject, :maker, :maker_medium,
  :maker_phone, :maker_email, :maker_site, :maker_address_street, :maker_address_city, :maker_address_state, :maker_address_zipcode, 
  :include_image, :include_title, :include_inventory_id, :include_creation_date, :include_quantity, :include_dimensions, :include_materials, :include_description, :include_income, :include_retail

  SALE =        { :name => "Sale",        :status => 'Sold',      :id => 1, :instant => false, :consumer => "client", :description => "Sale of work(s).",               :document => "Invoice" }
  SHOW =        { :name => "Show",        :status => 'Shown',     :id => 2, :instant => false, :consumer => "venue",  :description => "Show of work(s).",               :document => "Inventory List" }
  CONSIGNMENT = { :name => "Consignment", :status => 'Consigned', :id => 3, :instant => false, :consumer => "venue",  :description => "Consignment of work(s).",        :document => "Consignment Sheet" }
  GIFT =        { :name => "Gift",        :status => 'Gifted',    :id => 4, :instant => true,  :consumer => "client", :description => "Gift of work(s).",               :document => "Gift Summary" }
  DONATION =    { :name => "Donation",    :status => 'Donated',   :id => 5, :instant => true,  :consumer => "venue",  :description => "Donation of work(s).",           :document => "Donation Summary" }
  PORTFOLIO =   { :name => "Portfolio",   :status => 'Portfolio', :id => 6, :instant => true,  :consumer => "none",    :description => "Portfolio collection of works.", :document => "Portfolio" }
  LINE_SHEET =  { :name => "Line Sheet",  :status => 'Line Sheet',:id => 7, :instant => true,  :consumer => "none",    :description => "Line list of works.",            :document => "Line Sheet" }
  
  CATEGORIES_ARRAY = [SALE, SHOW, CONSIGNMENT, GIFT, DONATION, PORTFOLIO, LINE_SHEET]
  CATEGORY_NAMES_ARRAY = [SALE[:name], SHOW[:name], CONSIGNMENT[:name], GIFT[:name], DONATION[:name], PORTFOLIO[:name], LINE_SHEET[:name]]
  CATEGORY_IDS_ARRAY = [SALE[:id], SHOW[:id], CONSIGNMENT[:id], GIFT[:id], DONATION[:id], PORTFOLIO[:id], LINE_SHEET[:id]]
  CATEGORY_ID_NAME_HASH = { SALE[:id] => SALE[:name], SHOW[:id] => SHOW[:name], CONSIGNMENT[:id] => CONSIGNMENT[:name], GIFT[:id] => GIFT[:name], DONATION[:id] => DONATION[:name], PORTFOLIO[:id] => PORTFOLIO[:name], LINE_SHEET[:id] => LINE_SHEET[:name] }
  CATEGORY_ID_OBJECT_HASH = { SALE[:id] => SALE, SHOW[:id] => SHOW, CONSIGNMENT[:id] => CONSIGNMENT, GIFT[:id] => GIFT, DONATION[:id] => DONATION, PORTFOLIO[:id] => PORTFOLIO, LINE_SHEET[:id] => LINE_SHEET }
  CATEGORY_NAME_OBJECT_HASH = { SALE[:name] => SALE, SHOW[:name] => SHOW, CONSIGNMENT[:name] => CONSIGNMENT, GIFT[:name] => GIFT, DONATION[:name] => DONATION, PORTFOLIO[:name] => PORTFOLIO, LINE_SHEET[:name] => LINE_SHEET }

  belongs_to :user
  belongs_to :client
  belongs_to :venue

  has_many :activityworks, dependent: :destroy

  before_validation :set_remaining_ids

  validates_presence_of :user_id
  validates_presence_of :client_id
  validates_presence_of :venue_id
  validates_presence_of :date_start
  validates_presence_of :category_id
  validates_inclusion_of :category_id, :in => CATEGORY_IDS_ARRAY

  validate :date_end_validation
  
  validates_inclusion_of :include_image, :in => [true, false]
  validates_inclusion_of :include_title, :in => [true, false]
  validates_inclusion_of :include_inventory_id, :in => [true, false]
  validates_inclusion_of :include_creation_date, :in => [true, false]
  validates_inclusion_of :include_dimensions, :in => [true, false]
  validates_inclusion_of :include_materials, :in => [true, false]
  validates_inclusion_of :include_description, :in => [true, false]
  validates_inclusion_of :include_quantity, :in => [true, false]
  validates_inclusion_of :include_income, :in => [true, false]
  validates_inclusion_of :include_retail, :in => [true, false]

  scope :order_date_start, order: 'activities.date_start DESC'
  scope :of_type, lambda { | name | where('activities.category_id = ?', CATEGORY_NAME_OBJECT_HASH[name][:id]) }
  scope :current, lambda { | date | where('activities.date_start <= ? AND (activities.date_end IS NULL OR activities.date_end > ?)', date, date) }
  scope :sales, lambda { where('activities.category_id = ?', SALE[:id]) }
  scope :shows, lambda { where('activities.category_id = ?', SHOW[:id]) }
  scope :consignments, lambda { where('activities.category_id = ?', CONSIGNMENT[:id]) }
  scope :gifts, lambda { where('activities.category_id = ?', GIFT[:id]) }
  scope :donations, lambda { where('activities.category_id = ?', DONATION[:id]) }
  scope :portfolios, lambda { where('activities.category_id = ?', PORTFOLIO[:id]) }
  scope :line_sheets, lambda { where('activities.category_id = ?', LINE_SHEET[:id]) }

  def set_remaining_ids
    c = CATEGORY_ID_OBJECT_HASH[self.category_id]
    return if c.nil?
    if c[:consumer] != 'client'
      self.client_id = self.user.clients.find_by_name(Client::DEFAULT).id
    end
    if c[:consumer] != 'venue'
      self.venue_id = self.user.venues.find_by_name(Venue::DEFAULT).id 
    end 
    if c[:instant]
      self.date_end = self.date_start
    end
  end

  def set_activity_defaults
    self.maker = self.user.name
    self.maker_phone = self.user.phone 
    self.maker_email = self.user.email 
    self.maker_site = self.user.domain || (about_user(self.user) if self.user.share_about) 
    self.maker_address_street = self.user.address_street
    self.maker_address_city = self.user.address_city
    self.maker_address_state = self.user.address_state
    self.maker_address_zipcode = self.user.address_zipcode
    self.include_image = true
    self.include_title = true
    self.include_description = true
    self.include_quantity = true
    self.include_retail = true
    self
  end

  def date_end_validation
    if ! self.date_end.blank?
      errors.add("End date", "must be later than start date.") unless self.date_end >= self.date_start
    end
  end

  def activityworks_quantity
    ws = self.activityworks.all
    count = 0
    ws.each do | w |
      count = count + w.quantity
    end
    count
  end

  def activityworks_sold
    ws = self.activityworks.all
    count = 0
    ws.each do | w |
      count = count + w.sold
    end
    count
  end

  def startingBeforeDate(date)
    self.date_start <= date
  end

  def self.to_csv(records, category)
    if category == SALE[:name]
      header = ["client", "date", "paid_date", "work", "work id", "income", "retail", "sold"]
    elsif category == SHOW[:name] || category == CONSIGNMENT[:name]
      header = ["venue", "date_start", "date_end", "work", "work id", "income", "retail", "quantity", "sold"]
    elsif category == GIFT[:name]
       header = ["client", "date", "work", "work id", "income", "retail", "quantity"]
    elsif category == DONATION[:name]
       header = ["venue", "date", "work", "work id", "income", "retail", "quantity"]
    elsif category == PORTFOLIO[:name] || category == LINE_SHEET[:name]
      header = ["date", "work", "work id", "income", "retail", "quantity"]
    end
    CSV.generate do |csv|
      csv << header
      records.each do |r|
        aws = Activitywork.where('activity_id = ?',r.id).all
        aws.each do | aw |
          if category == SALE[:name]
            csv << [r.client.name, r.date_start, r.date_end, aw.work.title, aw.work.inventory_id, aw.income, aw.retail, aw.sold]
          elsif category == SHOW[:name] || category == CONSIGNMENT[:name]
            csv << [r.venue.name, r.date_start, r.date_end, aw.work.title, aw.work.inventory_id, aw.income, aw.retail, aw.quantity, aw.sold]
          elsif category == GIFT[:name]
            csv << [r.client.name, r.date_start, aw.work.title, aw.work.inventory_id, aw.income, aw.retail, aw.quantity]
          elsif category == DONATION[:name]
            csv << [r.venue.name, r.date_start, aw.work.title, aw.work.inventory_id, aw.income, aw.retail, aw.quantity]
          elsif category == PORTFOLIO[:name] || category == LINE_SHEET[:name]
            csv << [r.date_start, aw.work.title, aw.work.inventory_id, aw.income, aw.retail, aw.quantity]
          end
        end
      end
    end
  end

end
