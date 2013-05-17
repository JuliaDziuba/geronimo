# == Schema Information
#
# Table name: sites
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  brand             :string(255)
#  tag_line          :string(255)
#  email             :string(255)
#  phone             :string(255)
#  address_street    :string(255)
#  address_city      :string(255)
#  address_state     :string(255)
#  address_zipcode   :string(255)
#  domain            :string(255)
#  blog              :string(255)
#  social_etsy       :string(255)
#  social_googleplus :string(255)
#  social_facebook   :string(255)
#  social_linkedin   :string(255)
#  social_twitter    :string(255)
#  social_pinterest  :string(255)
#  bio_pic           :string(255)
#  bio_text          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Site < ActiveRecord::Base
  attr_accessible :address_city, :address_state, :address_street, :address_zipcode, :bio_pic, :bio_text, :blog, :brand, :domain, :email, :phone, :social_etsy, :social_googleplus, :social_facebook, :social_linkedin, :social_pinterest, :social_twitter, :tag_line
  
  belongs_to :user
  has_many :siteworks, dependent: :destroy
  has_many :sitevenues, dependent: :destroy
  has_many :works, :through => :siteworks
  has_many :venues,  :through => :sitevenues

  validates :brand, presence: true, length: { maximum: 30 }  
  validates :user_id, presence: true

  default_scope order: 'sites.brand'

end
