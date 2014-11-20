class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.integer :user_id
      t.integer :venuecategory_id
      t.string :name
      t.string :munged_name
      t.string :phone
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zipcode
      t.string :email
      t.string :site
      t.boolean :share_makers, default: false
      t.boolean :share_public, default: false

      t.timestamps
    end
    add_index :venues, [:user_id]
    add_index :venues, [:venuecategory_id]
    
  end
end