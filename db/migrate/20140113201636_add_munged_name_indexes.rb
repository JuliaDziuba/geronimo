class AddMungedNameIndexes < ActiveRecord::Migration
  def up
  	add_index :clients, [:munged_name]
  	add_index :venues, [:munged_name]
  end

  def down
  	remove_index :clients, [:munged_name]
  	remove_index :venues, [:munged_name]
  end
end
