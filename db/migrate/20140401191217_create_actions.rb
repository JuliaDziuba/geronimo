class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.date  :due
      t.string :action
      t.integer :actionable_id
      t.string  :actionable_type
      t.boolean :complete, defaut: false
      t.timestamps
    end

    add_index :actions, [:actionable_id]
    add_index :actions, [:actionable_type]
    
  end

  def self.down
    drop_table :actions
  end
end
