class AddItemToPaymentNotifications < ActiveRecord::Migration
  def change
  	add_column :payment_notifications, :item, :string
  end
end
