class FixNotes < ActiveRecord::Migration
  def change
  	rename_column :notes, :message, :note
  	remove_column :notes, :action    
  end
end
