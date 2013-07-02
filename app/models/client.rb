# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  phone           :string(255)
#  address_street  :string(255)
#  address_city    :string(255)
#  address_state   :string(255)
#  address_zipcode :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Client < ActiveRecord::Base
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :email, :name, :phone

  belongs_to :user
	has_many :activities

	before_validation :set_munged_name

	validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 30 }
	validates :munged_name, presence: true, uniqueness: { case_sensitive: false }
  
  default_scope order: 'clients.name'
  scope :all_known, lambda { where('clients.name != ?', 'Unknown') }

  def to_param
    munged_name
  end

  def set_munged_name
    self.munged_name = name.parameterize
  end
end
