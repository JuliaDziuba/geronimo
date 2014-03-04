class Payment Notification < ActiveRecord::Base
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

end
