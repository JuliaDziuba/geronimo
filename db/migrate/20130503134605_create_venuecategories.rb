class CreateVenuecategories < ActiveRecord::Migration
  def change
    create_table :venuecategories do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :venuecategories, [:name]
  end
end
