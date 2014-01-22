class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.string  :name
      t.string  :munged_name
      t.string  :category
      t.date    :date
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
    add_index :documents, [:user_id]
    add_index :documents, [:munged_name]
  end
end
