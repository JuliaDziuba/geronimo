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

ActiveRecord::Schema.define(:version => 20130517024939) do

  create_table "activities", :force => true do |t|
    t.integer  "activitycategory_id"
    t.integer  "venue_id"
    t.integer  "client_id"
    t.integer  "work_id"
    t.date     "date_start"
    t.date     "date_end"
    t.decimal  "income_wholesale"
    t.decimal  "income_retail"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "activities", ["activitycategory_id"], :name => "index_activities_on_activitycategory_id"
  add_index "activities", ["venue_id"], :name => "index_activities_on_venue_id"
  add_index "activities", ["work_id"], :name => "index_activities_on_work_id"

  create_table "activitycategories", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.boolean  "final"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "activitycategories", ["user_id", "name"], :name => "index_activitycategories_on_user_id_and_name"
  add_index "activitycategories", ["user_id"], :name => "index_activitycategories_on_user_id"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.integer  "address_zipcode"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sites", :force => true do |t|
    t.integer  "user_id"
    t.string   "brand"
    t.string   "tag_line"
    t.string   "email"
    t.string   "phone"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zipcode"
    t.string   "domain"
    t.string   "blog"
    t.string   "social_etsy"
    t.string   "social_googleplus"
    t.string   "social_facebook"
    t.string   "social_linkedin"
    t.string   "social_twitter"
    t.string   "social_pinterest"
    t.string   "bio_pic"
    t.string   "bio_text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "sites", ["user_id"], :name => "index_sites_on_user_id"

  create_table "sitevenues", :force => true do |t|
    t.integer  "site_id"
    t.integer  "venue_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sitevenues", ["site_id"], :name => "index_sitevenues_on_site_id"

  create_table "siteworks", :force => true do |t|
    t.integer  "site_id"
    t.integer  "work_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "siteworks", ["site_id"], :name => "index_siteworks_on_site_id"

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

  create_table "venuecategories", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "venuecategories", ["user_id"], :name => "index_venuecategories_on_user_id"

  create_table "venues", :force => true do |t|
    t.integer  "venuecategory_id"
    t.string   "name"
    t.integer  "phone"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.integer  "address_zipcode"
    t.string   "email"
    t.string   "site"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "venues", ["venuecategory_id"], :name => "index_venues_on_venuecategory_id"

  create_table "workcategories", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "user_id"
  end

  add_index "workcategories", ["user_id", "name"], :name => "index_workcategories_on_user_id_and_name"

  create_table "works", :force => true do |t|
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
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "image1_file_name"
    t.string   "image1_content_type"
    t.integer  "image1_file_size"
    t.datetime "image1_updated_at"
  end

  add_index "works", ["inventory_id"], :name => "index_works_on_inventory_id"
  add_index "works", ["title"], :name => "index_works_on_title"
  add_index "works", ["worksubcategory_id"], :name => "index_works_on_worksubcategory_id"

  create_table "worksubcategories", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "workcategory_id"
  end

  add_index "worksubcategories", ["workcategory_id", "name"], :name => "index_worksubcategories_on_workcategory_id_and_name"
  add_index "worksubcategories", ["workcategory_id"], :name => "index_worksubcategories_on_workcategory_id"

end
