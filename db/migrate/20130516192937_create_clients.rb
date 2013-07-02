class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :munged_name
      t.string :email
      t.string :phone
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.integer :address_zipcode
      t.integer :user_id

      t.timestamps
    end
  end
end
