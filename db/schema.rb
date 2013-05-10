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

ActiveRecord::Schema.define(:version => 20130507162656) do

  create_table "abstracts", :force => true do |t|
    t.text     "content_pt"
    t.string   "key_words_pt"
    t.text     "commentary"
    t.integer  "tcc_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "abstracts", ["tcc_id"], :name => "index_abstracts_on_tcc_id"

  create_table "bibliographies", :force => true do |t|
    t.text     "content"
    t.string   "direct_quote"
    t.string   "indirect_quote"
    t.integer  "tcc_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "bibliographies", ["tcc_id"], :name => "index_bibliographies_on_tcc_id"

  create_table "diaries", :force => true do |t|
    t.text     "content"
    t.integer  "pos"
    t.string   "title"
    t.integer  "hub_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "diaries", ["hub_id"], :name => "index_diaries_on_hub_id"

  create_table "final_considerations", :force => true do |t|
    t.text     "content"
    t.text     "commentary"
    t.integer  "tcc_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "final_considerations", ["tcc_id"], :name => "index_final_considerations_on_tcc_id"

  create_table "general_refs", :force => true do |t|
    t.string "direct_citation"
    t.string "indirect_citation"
    t.string "reference_text"
  end

  create_table "hubs", :force => true do |t|
    t.text     "reflection"
    t.text     "commentary"
    t.integer  "category"
    t.string   "state"
    t.integer  "tcc_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hubs", ["tcc_id"], :name => "index_hubs_on_tcc_id"

  create_table "presentations", :force => true do |t|
    t.text     "content"
    t.text     "commentary"
    t.integer  "tcc_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "presentations", ["tcc_id"], :name => "index_presentations_on_tcc_id"

  create_table "references", :force => true do |t|
    t.integer  "tcc_id"
    t.integer  "element_id"
    t.string   "element_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "references", ["element_id"], :name => "index_references_on_element_id"
  add_index "references", ["tcc_id"], :name => "index_references_on_tcc_id"

  create_table "tccs", :force => true do |t|
    t.string   "moodle_user"
    t.string   "title"
    t.string   "name"
    t.string   "leader"
    t.float    "grade"
    t.date     "defense_date"
    t.string   "state"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
