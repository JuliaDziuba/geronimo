class CreateWorktypes < ActiveRecord::Migration
  def change
    create_table :worktypes do |t|
      t.string :name
      t.string :description
      t.integer :user_id
    end
    add_index :worktypes, [:user_id, :name]
  end
end
