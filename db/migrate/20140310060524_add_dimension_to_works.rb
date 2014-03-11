class AddDimensionToWorks < ActiveRecord::Migration
  def change
  	add_column  :works, :dimension, :string
  end
end
