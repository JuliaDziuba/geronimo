class AddQuantityToActivity < ActiveRecord::Migration
  def change
  	add_column :activities, :quantity, :integer, default: 1
  end
end
