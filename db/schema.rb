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

ActiveRecord::Schema.define(version: 20181016025758) do

  create_table "abstracts", force: :cascade do |t|
    t.text     "content",    limit: 16777215
    t.text     "keywords",   limit: 16777215
    t.integer  "tcc_id",     limit: 4
    t.string   "state",      limit: 255,      default: "empty"
    t.date     "state_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstracts", ["tcc_id"], name: "index_abstracts_on_tcc_id", using: :btree

  create_table "article_refs", force: :cascade do |t|
    t.string  "first_author",       limit: 255
    t.string  "second_author",      limit: 255
    t.string  "third_author",       limit: 255
    t.boolean "et_all"
    t.string  "article_title",      limit: 255
    t.string  "article_subtitle",   limit: 255
    t.string  "journal_name",       limit: 255
    t.string  "local",              limit: 255
    t.integer "volume_number",      limit: 4
    t.integer "number_or_fascicle", limit: 4
    t.integer "year",               limit: 4
    t.integer "initial_page",       limit: 4
    t.integer "end_page",           limit: 4
    t.string  "subtype",            limit: 255
  end

  create_table "book_cap_refs", force: :cascade do |t|
    t.string   "cap_title",            limit: 255
    t.string   "cap_subtitle",         limit: 255
    t.string   "book_title",           limit: 255
    t.string   "book_subtitle",        limit: 255
    t.string   "first_part_author",    limit: 255
    t.string   "first_entire_author",  limit: 255
    t.string   "type_participation",   limit: 255
    t.string   "local",                limit: 255
    t.string   "publisher",            limit: 255
    t.integer  "year",                 limit: 4
    t.integer  "initial_page",         limit: 4
    t.integer  "end_page",             limit: 4
    t.string   "subtype",              limit: 255
    t.string   "second_entire_author", limit: 255
    t.string   "third_entire_author",  limit: 255
    t.string   "second_part_author",   limit: 255
    t.string   "third_part_author",    limit: 255
    t.boolean  "et_al_part"
    t.boolean  "et_al_entire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "book_refs", force: :cascade do |t|
    t.string   "first_author",   limit: 255
    t.string   "second_author",  limit: 255
    t.string   "third_author",   limit: 255
    t.boolean  "et_all"
    t.string   "title",          limit: 255
    t.string   "subtitle",       limit: 255
    t.integer  "edition_number", limit: 4
    t.string   "local",          limit: 255
    t.string   "publisher",      limit: 255
    t.integer  "year",           limit: 4
    t.string   "type_quantity",  limit: 255
    t.integer  "num_quantity",   limit: 4
    t.string   "subtype",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapter_definitions", force: :cascade do |t|
    t.integer  "tcc_definition_id", limit: 4
    t.string   "title",             limit: 255
    t.integer  "coursemodule_id",   limit: 4
    t.integer  "position",          limit: 4
    t.boolean  "is_numbered_title",             default: true
    t.boolean  "verify_references",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapter_definitions", ["tcc_definition_id"], name: "index_chapter_definitions_on_tcc_definition_id", using: :btree

  create_table "chapters", force: :cascade do |t|
    t.text     "content",               limit: 16777215
    t.integer  "position",              limit: 4
    t.integer  "tcc_id",                limit: 4
    t.integer  "chapter_definition_id", limit: 4
    t.string   "state",                 limit: 255,      default: "empty"
    t.date     "state_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["chapter_definition_id"], name: "index_chapters_on_chapter_definition_id", using: :btree
  add_index "chapters", ["tcc_id"], name: "index_chapters_on_tcc_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "comment",                  limit: 16777215
    t.integer  "chapter_commentable_id",   limit: 4
    t.string   "chapter_commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["chapter_commentable_id"], name: "index_comments_on_chapter_commentable_id", using: :btree

  create_table "compound_names", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_name",  limit: 255
  end

  create_table "decs", force: :cascade do |t|
    t.string   "dec_id",     limit: 255
    t.string   "dec_ds",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "decs", ["dec_ds"], name: "idx_decs_dec_ds", using: :btree
  add_index "decs", ["dec_id"], name: "idx_decs_dec_id", using: :btree

  create_table "internal_courses", force: :cascade do |t|
    t.integer  "internal_institution_id", limit: 4
    t.string   "course_name",             limit: 255
    t.string   "department_name",         limit: 255
    t.string   "center_name",             limit: 255
    t.string   "coordinator_name",        limit: 255
    t.string   "coordinator_gender",      limit: 1
    t.string   "presentation_data",       limit: 255
    t.string   "approval_data",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internal_institutions", force: :cascade do |t|
    t.string   "institution_name", limit: 255
    t.integer  "logo_width",       limit: 4
    t.string   "city",             limit: 255
    t.string   "data_file_name",   limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internet_refs", force: :cascade do |t|
    t.string   "first_author",              limit: 255
    t.string   "title",                     limit: 255
    t.string   "subtitle",                  limit: 255
    t.string   "url",                       limit: 255
    t.date     "access_date"
    t.string   "subtype",                   limit: 255
    t.string   "second_author",             limit: 255
    t.string   "third_author",              limit: 255
    t.date     "publication_date"
    t.boolean  "et_al"
    t.string   "complementary_information", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legislative_refs", force: :cascade do |t|
    t.string   "jurisdiction_or_header", limit: 255
    t.string   "title",                  limit: 255
    t.string   "edition",                limit: 255
    t.string   "local",                  limit: 255
    t.string   "publisher",              limit: 255
    t.integer  "year",                   limit: 4
    t.integer  "total_pages",            limit: 4
    t.string   "subtype",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moodle_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255,   null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "tcc_id",            limit: 4
    t.text     "etag",              limit: 65535
    t.string   "remote_filename",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moodle_assets", ["tcc_id"], name: "index_moodle_assets_on_tcc_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "moodle_username", limit: 255
    t.integer  "moodle_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", force: :cascade do |t|
    t.integer  "tcc_id",       limit: 4
    t.integer  "element_id",   limit: 4
    t.string   "element_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "references", ["element_id"], name: "index_references_on_element_id", using: :btree
  add_index "references", ["tcc_id"], name: "index_references_on_tcc_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "tcc_definitions", force: :cascade do |t|
    t.string   "internal_name",        limit: 255
    t.string   "activity_url",         limit: 255
    t.integer  "course_id",            limit: 4
    t.integer  "internal_course_id",   limit: 4
    t.date     "defense_date"
    t.integer  "moodle_instance_id",   limit: 4
    t.integer  "minimum_references",   limit: 4
    t.integer  "auto_save_minutes",    limit: 4
    t.integer  "pdf_link_hours",       limit: 4
    t.boolean  "enabled_sync",                     default: true
    t.string   "advisor_nomenclature", limit: 255, default: "orientador"
    t.string   "subject_area",         limit: 255, default: ""
    t.boolean  "ares_sync",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tcc_definitions", ["internal_course_id"], name: "index_tcc_definitions_on_internal_course_id", using: :btree

  create_table "tccs", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.date     "defense_date"
    t.integer  "orientador_id",     limit: 4
    t.integer  "student_id",        limit: 4
    t.integer  "tutor_id",          limit: 4
    t.integer  "tcc_definition_id", limit: 4
    t.integer  "grade",             limit: 4
    t.datetime "grade_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tccs", ["orientador_id"], name: "index_tcc_on_orientador_id", using: :btree
  add_index "tccs", ["student_id"], name: "index_tcc_on_student_id", using: :btree
  add_index "tccs", ["tcc_definition_id", "student_id"], name: "index_tcc_on_definition_student", unique: true, using: :btree
  add_index "tccs", ["tcc_definition_id"], name: "index_tccs_on_tcc_definition_id", using: :btree

  create_table "thesis_refs", force: :cascade do |t|
    t.string   "first_author",            limit: 255
    t.string   "title",                   limit: 255
    t.string   "subtitle",                limit: 255
    t.string   "local",                   limit: 255
    t.integer  "year",                    limit: 4
    t.integer  "year_of_submission",      limit: 4
    t.integer  "chapter",                 limit: 4
    t.string   "type_thesis",             limit: 255
    t.integer  "pages_or_volumes_number", limit: 4
    t.string   "type_number",             limit: 255
    t.string   "degree",                  limit: 255
    t.string   "institution",             limit: 255
    t.string   "course",                  limit: 255
    t.string   "department",              limit: 255
    t.string   "subtype",                 limit: 255
    t.string   "second_author",           limit: 255
    t.string   "third_author",            limit: 255
    t.boolean  "et_all"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
