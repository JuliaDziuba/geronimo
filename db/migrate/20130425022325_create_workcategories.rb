class CreateWorkcategories < ActiveRecord::Migration
  def change
    create_table :workcategories do |t|
      t.string :name
      t.string :description
      t.integer :user_id
    end
    add_index :workcategories, [:user_id, :name]
  end
end
