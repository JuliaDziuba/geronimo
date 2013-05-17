class CreateSitevenues < ActiveRecord::Migration
  def change
    create_table :sitevenues do |t|
      t.integer :site_id
      t.integer :venue_id

      t.timestamps
    end
    add_index :sitevenues, [:site_id]
  end
end
