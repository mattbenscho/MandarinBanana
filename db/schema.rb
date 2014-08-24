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

ActiveRecord::Schema.define(version: 20140822195301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "subtitle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hanzi_id"
  end

  add_index "comments", ["subtitle_id", "created_at"], name: "index_comments_on_subtitle_id_and_created_at", using: :btree

  create_table "examples", force: true do |t|
    t.integer  "expression_id"
    t.integer  "subtitle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "examples", ["expression_id", "subtitle_id"], name: "index_examples_on_expression_id_and_subtitle_id", unique: true, using: :btree
  add_index "examples", ["expression_id"], name: "index_examples_on_expression_id", using: :btree
  add_index "examples", ["subtitle_id"], name: "index_examples_on_subtitle_id", using: :btree

  create_table "gorodishes", force: true do |t|
    t.string   "element"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gorodishes", ["element"], name: "index_gorodishes_on_element", unique: true, using: :btree

  create_table "hanzis", force: true do |t|
    t.string   "character"
    t.string   "components"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hanzis", ["character"], name: "index_hanzis_on_character", using: :btree

  create_table "images", force: true do |t|
    t.text     "data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mnemonic_id"
  end

  create_table "mnemonics", force: true do |t|
    t.text     "aide"
    t.integer  "user_id"
    t.integer  "pinyindefinition_id"
    t.integer  "gorodish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "pinyindefinitions", force: true do |t|
    t.string   "pinyin"
    t.text     "definition"
    t.integer  "hanzi_id"
    t.string   "gbeginning"
    t.string   "gending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pinyindefinitions", ["hanzi_id", "pinyin", "definition"], name: "index_pinyindefinitions_on_hanzi_id_and_pinyin_and_definition", unique: true, using: :btree
  add_index "pinyindefinitions", ["hanzi_id", "pinyin"], name: "index_pinyindefinitions_on_hanzi_id_and_pinyin", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "hanzi_id"
    t.integer  "user_id"
    t.datetime "due"
    t.integer  "failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["due"], name: "index_reviews_on_due", using: :btree
  add_index "reviews", ["failed"], name: "index_reviews_on_failed", using: :btree
  add_index "reviews", ["hanzi_id", "user_id"], name: "index_reviews_on_hanzi_id_and_user_id", unique: true, using: :btree
  add_index "reviews", ["hanzi_id"], name: "index_reviews_on_hanzi_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "subtitles", force: true do |t|
    t.text     "sentence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
    t.string   "filename"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "wallposts", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallposts", ["parent_id", "created_at"], name: "index_wallposts_on_parent_id_and_created_at", using: :btree
  add_index "wallposts", ["user_id", "created_at"], name: "index_wallposts_on_user_id_and_created_at", using: :btree

end
