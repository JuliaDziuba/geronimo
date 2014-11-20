# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  type_id    :integer
#  name       :string(255)
#  date       :date
#  comment    :string(2000)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  attr_accessible :type_id, :name, :date, :comment
  
  BIO   = { :type => "Bio",   :id => 1 }
  STATEMENT   = { :type => "Statement",   :id => 2 }

  TYPE_HASH_BY_TYPE = { 
    BIO[:type] => BIO, 
    STATEMENT[:type] => STATEMENT 
  }

  TYPE_HASH_BY_ID = { 
    BIO[:id] => BIO, 
    STATEMENT[:id] => STATEMENT 
  }

  TYPES = [BIO, STATEMENT]

  belongs_to :user

  validates :user_id, presence: true
  validates :type_id, presence: true
  validates_inclusion_of :type_id, :in => [BIO[:id], STATEMENT[:id]]
  validates :name, presence: true, length: { maximum: 30 }
  validates :date, presence: true
  validates :comment, presence: true, length: { maximum: 2000 }

  scope :order_date, order: 'comments.date DESC' 
  scope :bios, lambda { where("type_id = ?", BIO[:id]) }
  scope :statements, lambda { where("type_id = ?", STATEMENT[:id]) }
  scope :of_type_id, lambda { | t | where("type_id = ?", t) }

  def self.to_csv(records, type)
    CSV.generate do |csv|
      csv << ["name", "date", type]
      records.each do |r|
        csv << [r.name,  r.date, r.comment]
      end
    end
  end
 
end
