class CreateActivitycategories < ActiveRecord::Migration
  def change
    create_table :activitycategories do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.string :status
      t.boolean :final

      t.timestamps
    end
    add_index :activitycategories, [:user_id]
    add_index :activitycategories, [:user_id, :name]
  end
end
