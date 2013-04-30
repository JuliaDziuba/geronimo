# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130426191215) do

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "workcategories", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "user_id"
  end

  add_index "workcategories", ["user_id", "name"], :name => "index_workcategories_on_user_id_and_name"

  create_table "works", :force => true do |t|
    t.integer  "user_id"
    t.integer  "workcategory_id"
    t.integer  "worksubcategory_id"
    t.string   "inventory_id"
    t.string   "title"
    t.date     "creation_date"
    t.decimal  "expense_hours"
    t.decimal  "expense_materials"
    t.decimal  "income_wholesale"
    t.decimal  "income_retail"
    t.string   "description"
    t.decimal  "dimention1"
    t.decimal  "dimention2"
    t.string   "dimention_units"
    t.string   "path_image1"
    t.string   "path_small_image1"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "works", ["inventory_id"], :name => "index_works_on_inventory_id"
  add_index "works", ["title"], :name => "index_works_on_title"
  add_index "works", ["user_id"], :name => "index_works_on_user_id"
  add_index "works", ["workcategory_id"], :name => "index_works_on_workcategory_id"
  add_index "works", ["worksubcategory_id"], :name => "index_works_on_worksubcategory_id"

  create_table "worksubcategories", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "workcategory_id"
  end

  add_index "worksubcategories", ["workcategory_id", "name"], :name => "index_worksubcategories_on_workcategory_id_and_name"
  add_index "worksubcategories", ["workcategory_id"], :name => "index_worksubcategories_on_workcategory_id"

end
