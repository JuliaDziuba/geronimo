# == Schema Information
#
# Table name: works
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  workcategory_id    :integer
#  worksubcategory_id :integer
#  inventory_id       :string(255)
#  title              :string(255)
#  creation_date      :date
#  expense_hours      :decimal(, )
#  expense_materials  :decimal(, )
#  income_wholesale   :decimal(, )
#  income_retail      :decimal(, )
#  description        :string(255)
#  dimention1         :decimal(, )
#  dimention2         :decimal(, )
#  dimention_units    :string(255)
#  path_image1        :string(255)
#  path_small_image1  :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Work < ActiveRecord::Base
  attr_accessible :creation_date, :description, :dimention1, :dimention2, :dimention_units, :expense_hours, :expense_materials, :income_retail, :income_wholesale, :inventory_id, :path_image1, :path_small_image1, :title, :workcategory_id, :worksubcategory_id
	belongs_to :user
	belongs_to :workcategory
	belongs_to :worksubcategory

	validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 300 }
  validates :user_id, presence: true
	
end
