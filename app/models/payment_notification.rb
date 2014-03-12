# == Schema Information
#
# Table name: payment_notifications
#
#  id             :integer          not null, primary key
#  params         :text
#  user_id        :integer
#  status         :string(255)
#  transaction_id :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item           :string(255)
#

class PaymentNotification < ActiveRecord::Base
  attr_accessible :params, :user_id, :item, :status, :transaction_id
  belongs_to :user
  serialize :params
  after_create :update_user_account

private

  def update_user_account
    if status == "Completed"
      if item == "Maker" 
        user.update_attribute(:tier, User::MAKER)
      elsif item == "Master" || item == "Upgrade to Master"
        user.update_attribute(:tier, User::MASTER) 
      end
    end
  end

end
