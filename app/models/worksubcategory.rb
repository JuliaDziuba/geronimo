# == Schema Information
#
# Table name: worksubcategories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  workcategory_id :integer
#

class Worksubcategory < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :user
  belongs_to :workcategory
  has_many   :works, dependent: :destroy

	validates :name, presence: true, length: { maximum: 25 }
  validates :description, length: { maximum: 500 }
  validates :workcategory_id, presence: true

	default_scope order: 'worksubcategories.name'
	
	class << self
		def id_from_name(user, name)
			user.worksubcategories.find_by_name(name).id
		end

		def full_categories(user)
      worksubcategories = user.worksubcategories
      worksubcategories.each do |worksubcategory|
        worksubcategory[:name] = worksubcategory.workcategory.name + " > " + worksubcategory.name
      end
    end
	end
end