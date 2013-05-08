class CreateVenuecategories < ActiveRecord::Migration
  def change
    create_table :venuecategories do |t|
      t.integer :user_id
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :venuecategories, [:user_id]
  end
end
