class AchernarCleanUp < ActiveRecord::Migration
  def change
    drop_table :activities
    drop_table :activitycategories
  	drop_table :documents
  	drop_table :venuecategories
  	drop_table :questions
  	add_column :users, :bio_id, :integer
    add_column :users, :statement_id, :integer
    add_column :clients, :site, :string
  	add_column :clients, :share, :boolean, default: false
    remove_column :users, :about
    rename_column :venues, :share_public, :share
    rename_column :works, :share_public, :share
    remove_column :works, :share_makers
    remove_column :venues, :share_makers
    remove_column :venues, :venuecategory_id

  	create_table :activities do |t|
	  	t.integer :user_id
      t.integer :category_id
      t.integer :client_id
      t.integer :venue_id
      t.date    :date_start
      t.date    :date_end
      t.text    :subject
      t.string  :maker
      t.string  :maker_medium
      t.string  :maker_phone
      t.string  :maker_email
      t.string  :maker_site
      t.string  :maker_address_street
      t.string  :maker_address_city
      t.string  :maker_address_state
      t.string  :maker_address_zipcode
      t.boolean :include_image, default: false
      t.boolean :include_title, default: false
      t.boolean :include_inventory_id, default: false
      t.boolean :include_creation_date, default: false
      t.boolean :include_quantity, default: false
      t.boolean :include_dimensions, default: false
      t.boolean :include_materials, default: false
      t.boolean :include_description, default: false
      t.boolean :include_income, default: false
      t.boolean :include_retail, default: false      

      t.timestamps
  	end

  	create_table :activityworks do |t|
      t.integer :activity_id
      t.integer :work_id
      t.decimal :income
      t.decimal :retail
      t.integer :quantity
      t.integer :sold

      t.timestamps
    end

    create_table :comments do |t|
      t.integer :user_id
      t.integer :type_id
      t.string  :name
      t.date    :date
      t.string :comment, :limit => 2000

      t.timestamps
    end

    add_index :activities, :user_id
    add_index :activities, :client_id
    add_index :activities, :venue_id
    add_index :activityworks, :activity_id
    add_index :activityworks, :work_id
    add_index :comments, :user_id
    add_index :comments, :type_id

  end

end