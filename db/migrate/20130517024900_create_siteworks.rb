class CreateSiteworks < ActiveRecord::Migration
  def change
    create_table :siteworks do |t|
      t.integer :site_id
      t.integer :work_id

      t.timestamps
    end
    add_index :siteworks, [:site_id]
  end
end
