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
#  work_id           :integer
#  venue_id          :integer
#  client_id         :integer
#  sold              :integer
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
  column :work_id, :integer
  column :venue_id, :integer
  column :client_id, :integer
  column :sold, :integer

  attr_accessible :sale_date, :expense_hours, :expense_materials, :retail, :income, :workcategory_id, :work_id, :venue_id, :client_id, :sold

  def self.buildFromSale(sale)
    work = sale.work
    activity = sale.activity
    w = SoldWork.new
    w.sale_date = activity.date_start
    w.venue_id = activity.venue_id
    w.client_id = activity.client_id
    w.expense_hours = work.expense_hours
    w.expense_materials = work.expense_materials
    w.retail = (sale.retail || work.retail)
    w.income = (sale.income || work.income)
    w.workcategory_id = work.workcategory_id
    w.work_id = work.id
    w.sold = sale.sold
    w
  end 
end
