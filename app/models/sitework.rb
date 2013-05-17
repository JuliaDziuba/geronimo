# == Schema Information
#
# Table name: siteworks
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  work_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sitework < ActiveRecord::Base
  attr_accessible :site_id, :work_id

  belongs_to :user
  belongs_to :site
  belongs_to :work

  validates :site_id, presence: true
  validates :work_id, presence: true
end
