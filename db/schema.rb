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

ActiveRecord::Schema.define(version: 20160717075134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "subtitle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hanzi_id"
  end

  add_index "comments", ["hanzi_id"], name: "index_comments_on_hanzi_id", using: :btree
  add_index "comments", ["subtitle_id", "created_at"], name: "index_comments_on_subtitle_id_and_created_at", using: :btree

  create_table "examples", force: :cascade do |t|
    t.integer  "expression_id"
    t.integer  "subtitle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "examples", ["expression_id", "subtitle_id"], name: "index_examples_on_expression_id_and_subtitle_id", unique: true, using: :btree
  add_index "examples", ["expression_id"], name: "index_examples_on_expression_id", using: :btree
  add_index "examples", ["subtitle_id"], name: "index_examples_on_subtitle_id", using: :btree

  create_table "featured_images", force: :cascade do |t|
    t.text     "data"
    t.text     "mnemonic_aide"
    t.integer  "hanzi_id"
    t.text     "commentary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pinyindefinition_id"
  end

  add_index "featured_images", ["created_at"], name: "index_featured_images_on_created_at", using: :btree
  add_index "featured_images", ["hanzi_id"], name: "index_featured_images_on_hanzi_id", using: :btree

  create_table "gorodishes", force: :cascade do |t|
    t.string   "element",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gorodishes", ["element"], name: "index_gorodishes_on_element", unique: true, using: :btree

  create_table "hanzis", force: :cascade do |t|
    t.string   "character",  limit: 255
    t.string   "components", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frequency",              default: 0
    t.integer  "HSK"
  end

  add_index "hanzis", ["character"], name: "index_hanzis_on_character", using: :btree
  add_index "hanzis", ["frequency"], name: "index_hanzis_on_frequency", using: :btree

  create_table "images", force: :cascade do |t|
    t.text     "data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mnemonic_id"
  end

  add_index "images", ["mnemonic_id"], name: "index_images_on_mnemonic_id", using: :btree

  create_table "mnemonics", force: :cascade do |t|
    t.text     "aide"
    t.integer  "user_id"
    t.integer  "pinyindefinition_id"
    t.integer  "gorodish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mnemonics", ["created_at"], name: "index_mnemonics_on_created_at", using: :btree
  add_index "mnemonics", ["gorodish_id"], name: "index_mnemonics_on_gorodish_id", using: :btree
  add_index "mnemonics", ["pinyindefinition_id"], name: "index_mnemonics_on_pinyindefinition_id", using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "pinyindefinitions", force: :cascade do |t|
    t.string   "pinyin",     limit: 255
    t.text     "definition"
    t.integer  "hanzi_id"
    t.string   "gbeginning", limit: 255
    t.string   "gending",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pinyindefinitions", ["hanzi_id", "pinyin", "definition"], name: "index_pinyindefinitions_on_hanzi_id_and_pinyin_and_definition", unique: true, using: :btree
  add_index "pinyindefinitions", ["hanzi_id", "pinyin"], name: "index_pinyindefinitions_on_hanzi_id_and_pinyin", using: :btree
  add_index "pinyindefinitions", ["hanzi_id"], name: "index_pinyindefinitions_on_hanzi_id", using: :btree

  create_table "simplifieds", force: :cascade do |t|
    t.integer  "trad_id"
    t.integer  "simp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simplifieds", ["simp_id"], name: "index_simplifieds_on_simp_id", using: :btree
  add_index "simplifieds", ["trad_id", "simp_id"], name: "index_simplifieds_on_trad_id_and_simp_id", unique: true, using: :btree
  add_index "simplifieds", ["trad_id"], name: "index_simplifieds_on_trad_id", using: :btree

  create_table "subtitles", force: :cascade do |t|
    t.text     "sentence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
    t.string   "filename",   limit: 255
    t.text     "words"
    t.text     "pinyin"
    t.integer  "HSK"
    t.text     "english",                default: ""
    t.text     "chinglish",              default: ""
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: 255
    t.string   "remember_token",  limit: 255
    t.boolean  "admin",                       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "wallposts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallposts", ["parent_id", "created_at"], name: "index_wallposts_on_parent_id_and_created_at", using: :btree
  add_index "wallposts", ["user_id", "created_at"], name: "index_wallposts_on_user_id_and_created_at", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "simplified"
    t.text     "translation"
    t.integer  "HSK"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "traditional"
    t.string   "pinyin"
    t.string   "frequency"
  end

  add_index "words", ["HSK"], name: "index_words_on_HSK", using: :btree
  add_index "words", ["frequency"], name: "index_words_on_frequency", using: :btree
  add_index "words", ["simplified"], name: "index_words_on_simplified", using: :btree
  add_index "words", ["traditional"], name: "index_words_on_traditional", using: :btree

end
