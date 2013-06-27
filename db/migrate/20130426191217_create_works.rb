class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.integer :user_id
      t.integer :workcategory_id
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
      t.boolean :share_makers, default: false
      t.boolean :share_public, default: false

      t.timestamps
    end
    add_index :works, [:user_id]
    add_index :works, [:workcategory_id]
    add_index :works, [:inventory_id]
    add_index :works, [:title]
    add_attachment :works, :image1
  end
end
