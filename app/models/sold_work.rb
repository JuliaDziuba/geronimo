# == Schema Information
#
# Table name: sold_works
#
#  sale_date         :date
#  expense_hours     :decimal(, )
#  expense_materials :decimal(, )
#  retail            :decimal(, )
#  income            :decimal(, )
#  workcategory_id   :integer
#  venue_id          :integer
#  client_id         :integer
#

class SoldWork < ActiveRecord::Base
  def self.columns() @columns ||= []; end
 
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :sale_date, :date
  column :expense_hours, :decimal
  column :expense_materials, :decimal
  column :retail, :decimal
  column :income, :decimal
  column :workcategory_id, :integer
  column :venue_id, :integer
  column :client_id, :integer

  attr_accessible :sale_date, :expense_hours, :expense_materials, :retail, :income, :workcategory_id, :venue_id, :client_id

  default_scope order: 'works.creation_date DESC'
 
  def createFromWorkAndSale(work, sale)
    sale_date = sale.date_start 
    venue_id = sale.venue_id
    client_id = sale.client_id
    expense_hours = work.expense_hours
    expense_materials = work.expense_materials
    retail = (sale.retail || work.retail)
    income = (sale.income || work.income)
    workcategory_id = work.workcategory_id
    self
  end 
end
