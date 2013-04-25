class CreateWorksubtypes < ActiveRecord::Migration
  def change
    create_table :worksubtypes do |t|
      t.string :name
      t.string :description
      t.integer :worktype_id
    end
     add_index :worksubtypes, [:worktype_id, :name]
  end
end
