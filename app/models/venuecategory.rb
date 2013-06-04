
class Venuecategory < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :user
	has_many :venues

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  
end
