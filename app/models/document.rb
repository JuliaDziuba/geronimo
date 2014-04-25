# == Schema Information
#
# Table name: documents
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  name                  :string(255)
#  munged_name           :string(255)
#  category              :string(255)
#  date                  :date
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
#  include_dimensions    :boolean          default(FALSE)
#  include_materials     :boolean          default(FALSE)
#  include_description   :boolean          default(FALSE)
#  include_income        :boolean          default(FALSE)
#  include_retail        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  include_quantity      :boolean          default(FALSE)
#

class Document < ActiveRecord::Base
  attr_accessible :name, :munged_name, :category, :date, :date_start, :date_end, :subject, :maker, :maker_medium,
  :maker_phone, :maker_email, :maker_site, :maker_address_street, :maker_address_city, :maker_address_state, :maker_address_zipcode, 
  :include_image, :include_title, :include_inventory_id, :include_creation_date, :include_quantity, :include_dimensions, :include_materials, :include_description, :include_income, :include_retail

  CONSIGNMENT = "Consignment sheet"
  INVOICE = "Invoice"
  PORTFOLIO = "Portfolio page"
  PRICE = "Price list"
  DOCUMENTS_ARRAY = [Document::CONSIGNMENT, Document::INVOICE, Document::PORTFOLIO, Document::PRICE]

  belongs_to :user

  before_save :set_munged_name

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 70 }
  validates_uniqueness_of :name, :scope => :user_id, :case_sensitive => false
  validate :munged_name_is_unique

  validates_presence_of :maker
  validates_presence_of :date
  validates_presence_of :category
  validates_inclusion_of :category, :in => Document::DOCUMENTS_ARRAY
  validate :subject_is_present 
  validates_presence_of :date_start, :if => :datesRequired?
  validates_presence_of :date_end, :if => :datesRequired? 
  
  validates_inclusion_of :include_image, :in => [true, false]
  validates_inclusion_of :include_title, :in => [true, false]
  validates_inclusion_of :include_inventory_id, :in => [true, false]
  validates_inclusion_of :include_creation_date, :in => [true, false]
  validates_inclusion_of :include_dimensions, :in => [true, false]
  validates_inclusion_of :include_materials, :in => [true, false]
  validates_inclusion_of :include_description, :in => [true, false]
  validates_inclusion_of :include_income, :in => [true, false]
  validates_inclusion_of :include_retail, :in => [true, false]

  default_scope order: 'documents.date DESC'
  scope :excluding_current, lambda { | id | where('documents.id != ?', id) }

  def to_param
    munged_name
  end

  def set_munged_name
    self.munged_name = name.parameterize
  end

  def munged_name_is_unique
    return unless errors.blank?
    munged_name_unique = self.user.documents.excluding_current(self.id).find_by_munged_name(name.parameterize).nil?
    errors.add(:name, "is too similar to an existing name and will not result in a unique URL") unless (munged_name_unique)
  end

  def subject_is_present
    return unless subject.blank?
    message = "needed. Please pick the works to include."
    if self.category == CONSIGNMENT 
      message = "needed. Please pick the venue the consignment sheet is for." 
    elsif self.category == INVOICE 
      message = "needed. Please pick the client the invoice is for."   
    end
    errors.add(:subject, message)
  end

  def datesRequired?
    self.category == CONSIGNMENT || self.category == INVOICE
  end
  
end
