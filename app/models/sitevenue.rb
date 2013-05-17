# == Schema Information
#
# Table name: sitevenues
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  venue_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sitevenue < ActiveRecord::Base
  attr_accessible :site_id, :venue_id

  belongs_to :user
  belongs_to :site
  belongs_to :venue

  validates :site_id, presence: true
  validates :venue_id, presence: true
end
