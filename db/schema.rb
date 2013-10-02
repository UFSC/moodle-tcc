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

ActiveRecord::Schema.define(:version => 20131001115534) do

  create_table "abstracts", :force => true do |t|
    t.text     "content",    :limit => 16777215
    t.string   "key_words"
    t.text     "commentary"
    t.integer  "tcc_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "state"
  end

  add_index "abstracts", ["tcc_id"], :name => "index_abstracts_on_tcc_id"

  create_table "article_refs", :force => true do |t|
    t.string  "first_author"
    t.string  "second_author"
    t.string  "third_author"
    t.boolean "et_all"
    t.string  "article_title"
    t.string  "article_subtitle"
    t.string  "journal_name"
    t.string  "local"
    t.integer "volume_number"
    t.integer "number_or_fascicle"
    t.integer "year"
    t.integer "initial_page"
    t.integer "end_page"
    t.string  "subtype"
  end

  create_table "book_cap_refs", :force => true do |t|
    t.string  "cap_title"
    t.string  "cap_subtitle"
    t.string  "book_title"
    t.string  "book_subtitle"
    t.string  "cap_author"
    t.string  "book_author"
    t.string  "type_participation"
    t.string  "local"
    t.string  "publisher"
    t.integer "year"
    t.integer "initial_page"
    t.integer "end_page"
    t.string  "subtype"
  end

  create_table "book_refs", :force => true do |t|
    t.string  "first_author"
    t.string  "second_author"
    t.string  "third_author"
    t.boolean "et_all"
    t.string  "title"
    t.string  "subtitle"
    t.integer "edition_number"
    t.string  "local"
    t.string  "publisher"
    t.integer "year"
    t.string  "type_quantity"
    t.integer "num_quantity"
    t.string  "subtype"
  end

  create_table "diaries", :force => true do |t|
    t.text     "content",             :limit => 16777215
    t.integer  "position"
    t.integer  "hub_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "diary_definition_id"
  end

  add_index "diaries", ["diary_definition_id"], :name => "index_diaries_on_diary_definition_id"
  add_index "diaries", ["hub_id"], :name => "index_diaries_on_hub_id"

  create_table "diary_definitions", :force => true do |t|
    t.integer  "hub_definition_id"
    t.integer  "external_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "diary_definitions", ["hub_definition_id"], :name => "index_diary_definitions_on_hub_definition_id"

  create_table "final_considerations", :force => true do |t|
    t.text     "content",    :limit => 16777215
    t.text     "commentary"
    t.integer  "tcc_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "state"
  end

  add_index "final_considerations", ["tcc_id"], :name => "index_final_considerations_on_tcc_id"

  create_table "general_refs", :force => true do |t|
    t.string "direct_citation"
    t.string "indirect_citation"
    t.string "reference_text"
  end

  create_table "hub_definitions", :force => true do |t|
    t.integer  "tcc_definition_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "moodle_shortname"
  end

  add_index "hub_definitions", ["tcc_definition_id"], :name => "index_hub_definitions_on_tcc_definition_id"

  create_table "hubs", :force => true do |t|
    t.text     "reflection",        :limit => 16777215
    t.text     "commentary"
    t.integer  "position"
    t.string   "state"
    t.float    "grade"
    t.integer  "tcc_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "portfolio_state"
    t.integer  "hub_definition_id"
    t.string   "type"
  end

  add_index "hubs", ["hub_definition_id"], :name => "index_hubs_on_hub_definition_id"
  add_index "hubs", ["tcc_id"], :name => "index_hubs_on_tcc_id"

  create_table "internet_refs", :force => true do |t|
    t.string "author"
    t.string "title"
    t.string "subtitle"
    t.string "url"
    t.date   "access_date"
    t.string "subtype"
  end

  create_table "legislative_refs", :force => true do |t|
    t.string  "jurisdiction_or_header"
    t.string  "title"
    t.string  "edition"
    t.string  "local"
    t.string  "publisher"
    t.integer "year"
    t.integer "total_pages"
    t.string  "subtype"
  end

  create_table "presentations", :force => true do |t|
    t.text     "content",    :limit => 16777215
    t.text     "commentary"
    t.integer  "tcc_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "state"
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

  create_table "tcc_definitions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tccs", :force => true do |t|
    t.string   "moodle_user"
    t.string   "title"
    t.string   "name"
    t.string   "leader"
    t.float    "grade"
    t.date     "defense_date"
    t.string   "state"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "tutor_group"
    t.integer  "tcc_definition_id"
    t.string   "orientador"
    t.string   "email_estudante"
    t.string   "email_orientador"
  end

  add_index "tccs", ["tcc_definition_id"], :name => "index_tccs_on_tcc_definition_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",                        :null => false
    t.integer  "item_id",                          :null => false
    t.string   "event",                            :null => false
    t.string   "whodunnit"
    t.text     "object",     :limit => 2147483647
    t.datetime "created_at"
    t.text     "comment"
    t.string   "state"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
