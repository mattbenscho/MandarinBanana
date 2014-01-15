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

ActiveRecord::Schema.define(version: 20140115202942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "subtitle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["subtitle_id", "created_at"], name: "index_comments_on_subtitle_id_and_created_at", using: :btree

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
  end

  create_table "movies", force: true do |t|
    t.string   "title"
    t.string   "youtube_id"
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

  create_table "subtitles", force: true do |t|
    t.text     "sentence"
    t.integer  "start"
    t.integer  "stop"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
  end

  add_index "subtitles", ["start"], name: "index_subtitles_on_start", using: :btree

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

end
