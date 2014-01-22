class AddMaterialsAndQuantityToWork < ActiveRecord::Migration
  def change
  	add_column :works, :materials, :string
    add_column :works, :quantity, :integer, default: 1
  end
end
