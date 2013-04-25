class CreateWorktypesubs < ActiveRecord::Migration
  def change
    create_table :worktypesubs do |t|
      t.string :name
      t.string :description
      t.integer :worktype_id
    end
     add_index :worktypesubs, [:worktype_id, :name]
  end
end
