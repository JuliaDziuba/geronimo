class CreateWorksubcategories < ActiveRecord::Migration
  def change
    create_table :worksubcategories do |t|
      t.string :name
      t.string :description
      t.integer :workcategory_id
    end
     add_index :worksubcategories, [:workcategory_id]
     add_index :worksubcategories, [:workcategory_id, :name]
  end
end
