class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :user_id
      t.string :brand
      t.string :tag_line
      t.string :email
      t.string :phone
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zipcode
      t.string :domain
      t.string :blog
      t.string :social_facebook
      t.string :social_twitter
      t.string :social_pinterest
      t.string :bio_pic
      t.string :bio_text

      t.timestamps
    end
    add_index :sites, [:user_id]
  end
end
