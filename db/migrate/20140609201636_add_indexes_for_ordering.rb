class AddIndexesForOrdering < ActiveRecord::Migration
  def up
  	add_index :clients, [:name]
  	add_index :venues, [:name]
  	add_index :actions, [:due]
  	add_index :workcategories, [:name]
  end

  def down
  	remove_index :clients, [:name]
  	remove_index :venues, [:name]
  	remove_index :actions, [:due]
  	remove_index :workcategories, [:name]
  end
end
