class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.date  :date
      t.string :note
      t.integer :notable_id
      t.string  :notable_type
      t.timestamps
    end

    add_index :notes, [:notable_id]
    add_index :notes, [:notable_type]
    
  end

  def self.down
    drop_table :notes
  end
end
