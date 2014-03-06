class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

def create
  PaymentNotification.create!(:params => params, :user_id => current_user, :item => params[:item_name], :status => params[:payment_status], :transaction_id => params[:txn_id])
  render :nothing => true
end

end
