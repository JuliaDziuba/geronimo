class RemoveAndEditDimensionColumnsInWorks < ActiveRecord::Migration
  def change
  	rename_column :works, :dimension, :dimensions
  	remove_column :works, :dimention1
  	remove_column :works, :dimention2
  	remove_column :works, :dimention_units
  end
end
