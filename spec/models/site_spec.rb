# == Schema Information
#
# Table name: sites
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  brand            :string(255)
#  tag_line         :string(255)
#  email            :string(255)
#  phone            :string(255)
#  address_street   :string(255)
#  address_city     :string(255)
#  address_state    :string(255)
#  address_zipcode  :string(255)
#  domain           :string(255)
#  blog             :string(255)
#  social_facebook  :string(255)
#  social_twitter   :string(255)
#  social_pinterest :string(255)
#  bio_pic          :string(255)
#  bio_text         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Site do
  pending "add some examples to (or delete) #{__FILE__}"
end
