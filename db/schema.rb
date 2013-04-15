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

ActiveRecord::Schema.define(:version => 20130401201417) do

  create_table "bibliographies", :force => true do |t|
    t.text     "content"
    t.integer  "tcc_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bibliographies", ["tcc_id"], :name => "index_bibliographies_on_tcc_id"

  create_table "diaries", :force => true do |t|
    t.text     "content"
    t.integer  "hub_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "diaries", ["hub_id"], :name => "index_diaries_on_hub_id"

  create_table "hubs", :force => true do |t|
    t.text     "reflection"
    t.text     "commentary"
    t.integer  "category"
    t.integer  "tcc_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hubs", ["tcc_id"], :name => "index_hubs_on_tcc_id"

  create_table "tccs", :force => true do |t|
    t.string   "moodle_user"
    t.string   "title"
    t.text     "abstract"
    t.string   "abstract_key_words"
    t.text     "abstract_commentary"
    t.text     "english_abstract"
    t.string   "english_abstract_key_words"
    t.text     "english_abstract_commentary"
    t.text     "presentation"
    t.text     "presentation_commentary"
    t.text     "final_considerations"
    t.text     "final_considerations_commentary"
    t.string   "name"
    t.string   "leader"
    t.float    "grade"
    t.integer  "year_defense"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

end
