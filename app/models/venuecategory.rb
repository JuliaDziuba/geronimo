# == Schema Information
#
# Table name: venuecategories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Venuecategory < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :user
	has_many :venues

  validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 150 }
  validates :user_id, presence: true

	default_scope order: 'venuecategories.name'
  
end
