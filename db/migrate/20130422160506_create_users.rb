class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :admin, defaut: false
      t.string :about
      t.string :name
      t.string :email
      t.string :location_city
      t.string :location_state
      t.string :password_digest
      t.string :remember_token
      t.string :username
     
      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index  :users, :remember_token
    add_attachment :users, :image
  end
end