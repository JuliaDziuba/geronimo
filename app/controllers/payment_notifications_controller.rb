class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

def create
  PaymentNotification.create!(:params => params, :user_id => params[:custom], :item => params[:option_selection1], :status => params[:payment_status], :transaction_id => params[:txn_id])
  render :nothing => true
end

def show
	@user = current_user
end

def success
	@user = current_user
end

def failure
	@user = current_user
end

end
