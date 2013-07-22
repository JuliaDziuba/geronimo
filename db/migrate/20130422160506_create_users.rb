class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :admin, defaut: false
      t.boolean :share_with_makers, defaut: false
      t.boolean :share_with_public, defaut: false
      t.boolean :share_about, defaut: false
      t.boolean :share_contact, defaut: false
      t.boolean :share_price, default: false
      t.boolean :share_purchase, defaut: false
      t.boolean :share_works, defaut: false
      t.string :username
      t.string :password_digest
      t.string :remember_token
      t.string :name
      t.string :domain
      t.string :tag_line
      t.string :blog
      t.string :about, :limit => 2000
      t.string :email
      t.string :phone
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zipcode
      t.string :social_etsy
      t.string :social_googleplus
      t.string :social_facebook
      t.string :social_linkedin
      t.string :social_twitter
      t.string :social_pinterest
    
      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index  :users, :remember_token
    add_attachment :users, :image
  end
end
