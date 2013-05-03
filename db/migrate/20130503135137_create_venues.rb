class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.integer :user_id
      t.integer :venuecategory_id
      t.string :name
      t.integer :phone
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.integer :address_zipcode
      t.string :email
      t.string :site

      t.timestamps
    end
  end
end
