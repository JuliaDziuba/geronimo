class CreateWorkcategories < ActiveRecord::Migration
  def change
    create_table :workcategories do |t|
      t.integer :user_id
      t.string :name
      t.string :artist_statement, :limit => 1000
      t.integer :parent_id
    end
    add_index :workcategories, [:user_id]
    add_index :workcategories, [:parent_id]
  end
end
