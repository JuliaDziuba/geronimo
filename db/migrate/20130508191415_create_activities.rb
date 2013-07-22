class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :activitycategory_id
      t.integer :venue_id
      t.integer :client_id
      t.integer :work_id
      t.date :date_start
      t.date :date_end
      t.decimal :income
      t.decimal :retail

      t.timestamps
    end
    add_index :activities, [:user_id]
    add_index :activities, [:activitycategory_id]
    add_index :activities, [:venue_id]
    add_index :activities, [:work_id]
  end
end
