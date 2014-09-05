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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140902211046) do

  create_table "abstracts", force: true do |t|
    t.text     "content",    limit: 16777215
    t.string   "keywords"
    t.integer  "tcc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstracts", ["tcc_id"], name: "index_abstracts_on_tcc_id", using: :btree

  create_table "article_refs", force: true do |t|
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

  create_table "book_cap_refs", force: true do |t|
    t.string  "cap_title"
    t.string  "cap_subtitle"
    t.string  "book_title"
    t.string  "book_subtitle"
    t.string  "first_part_author"
    t.string  "first_entire_author"
    t.string  "type_participation"
    t.string  "local"
    t.string  "publisher"
    t.integer "year"
    t.integer "initial_page"
    t.integer "end_page"
    t.string  "subtype"
    t.string  "second_entire_author"
    t.string  "third_entire_author"
    t.string  "second_part_author"
    t.string  "third_part_author"
    t.boolean "et_al_part"
    t.boolean "et_al_entire"
  end

  create_table "book_refs", force: true do |t|
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

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "compound_names", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_name"
  end

  create_table "final_considerations", force: true do |t|
    t.text     "content",    limit: 16777215
    t.integer  "tcc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "final_considerations", ["tcc_id"], name: "index_final_considerations_on_tcc_id", using: :btree

  create_table "general_refs", force: true do |t|
    t.string "direct_citation"
    t.string "indirect_citation"
    t.string "reference_text"
  end

  create_table "hub_definitions", force: true do |t|
    t.integer  "tcc_definition_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "moodle_shortname"
    t.string   "subtitle"
  end

  add_index "hub_definitions", ["tcc_definition_id"], name: "index_hub_definitions_on_tcc_definition_id", using: :btree

  create_table "hubs", force: true do |t|
    t.text     "reflection",        limit: 16777215
    t.integer  "position"
    t.string   "state"
    t.float    "grade"
    t.integer  "tcc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hub_definition_id"
    t.string   "type"
    t.string   "reflection_title"
  end

  add_index "hubs", ["hub_definition_id"], name: "index_hubs_on_hub_definition_id", using: :btree
  add_index "hubs", ["tcc_id"], name: "index_hubs_on_tcc_id", using: :btree

  create_table "internet_refs", force: true do |t|
    t.string  "first_author"
    t.string  "title"
    t.string  "subtitle"
    t.string  "url"
    t.date    "access_date"
    t.string  "subtype"
    t.string  "second_author"
    t.string  "third_author"
    t.date    "publication_date"
    t.boolean "et_al"
    t.string  "complementary_information"
  end

  create_table "legislative_refs", force: true do |t|
    t.string  "jurisdiction_or_header"
    t.string  "title"
    t.string  "edition"
    t.string  "local"
    t.string  "publisher"
    t.integer "year"
    t.integer "total_pages"
    t.string  "subtype"
  end

  create_table "moodle_assets", force: true do |t|
    t.string   "data_file_name",    null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "tcc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moodle_assets", ["tcc_id"], name: "index_moodle_assets_on_tcc_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "moodle_username"
    t.integer  "moodle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", force: true do |t|
    t.text     "content",    limit: 16777215
    t.integer  "tcc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presentations", ["tcc_id"], name: "index_presentations_on_tcc_id", using: :btree

  create_table "references", force: true do |t|
    t.integer  "tcc_id"
    t.integer  "element_id"
    t.string   "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "references", ["element_id"], name: "index_references_on_element_id", using: :btree
  add_index "references", ["tcc_id"], name: "index_references_on_tcc_id", using: :btree

  create_table "tcc_definitions", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "activity_url"
    t.integer  "course_id"
    t.date     "defense_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tccs", force: true do |t|
    t.string   "title"
    t.date     "defense_date"
    t.integer  "orientador_id"
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tcc_definition_id"
  end

  add_index "tccs", ["tcc_definition_id"], name: "index_tccs_on_tcc_definition_id", using: :btree

  create_table "thesis_refs", force: true do |t|
    t.string  "author"
    t.string  "title"
    t.string  "subtitle"
    t.string  "local"
    t.integer "year"
    t.integer "year_of_submission"
    t.integer "chapter"
    t.string  "type_thesis"
    t.integer "pages_or_volumes_number"
    t.string  "type_number"
    t.string  "degree"
    t.string  "institution"
    t.string  "course"
    t.string  "department"
    t.string  "subtype"
  end

end
