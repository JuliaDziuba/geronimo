class EditAndAddShareColumnsOfUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :share_price, :share_works_price
  	add_column :users, :share_works_status, :boolean, default: true
  	add_column :users, :share_works_materials, :boolean, default: true
  	add_column :users, :share_works_dimensions, :boolean, default: true
  	add_column :users, :share_works_description, :boolean, default: true
    change_column :users, :admin, :boolean, default: false
    change_column :users, :share_with_makers, :boolean, default: false
    change_column :users, :share_with_public, :boolean, default: false
    change_column :users, :share_about, :boolean, default: false
    change_column :users, :share_contact, :boolean, default: false
    change_column :users, :share_purchase, :boolean, default: false
    change_column :users, :share_works, :boolean, default: false
    change_column :users, :share_works_price, :boolean, default: false    
  end
end
