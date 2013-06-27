class CreateActivitycategories < ActiveRecord::Migration
  def change
    create_table :activitycategories do |t|
      t.string :name
      t.string :description
      t.string :status
      t.boolean :final, default: false

      t.timestamps
    end
   add_index :activitycategories, [:name]
  end
end
