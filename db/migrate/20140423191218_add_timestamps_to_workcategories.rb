class AddTimestampsToWorkcategories < ActiveRecord::Migration
  def self.up # Or `def up` in 3.1
        change_table :workcategories do |t|
            t.timestamps
        end
    end
    def self.down # Or `def down` in 3.1
        remove_column :workcategories, :created_at
        remove_column :workcategories, :updated_at
    end
end
