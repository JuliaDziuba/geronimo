class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.integer :worksubcategory_id
      t.string  :inventory_id
      t.string  :title
      t.date    :creation_date
      t.decimal :expense_hours
      t.decimal :expense_materials
      t.decimal :income_wholesale
      t.decimal :income_retail
      t.string  :description
      t.decimal :dimention1
      t.decimal :dimention2
      t.string  :dimention_units
      t.string  :path_image1
      t.string  :path_small_image1

      t.timestamps
    end
    add_index :works, [:worksubcategory_id]
    add_index :works, [:inventory_id]
    add_index :works, [:title]
  end
end
