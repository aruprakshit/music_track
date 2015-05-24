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

ActiveRecord::Schema.define(version: 20150523111220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "event_type"
    t.string   "end_reason_type"
    t.integer  "customer_id",      limit: 8
    t.string   "device_type"
    t.integer  "track_owner"
    t.integer  "station_id",       limit: 8
    t.string   "storefront_name"
    t.string   "cma_flag"
    t.string   "heat_seeker_flag"
    t.datetime "created_at",                 default: '2015-05-23 16:18:24', null: false
    t.datetime "updated_at",                 default: '2015-05-23 16:18:24', null: false
    t.integer  "apple_id",         limit: 8
    t.date     "start_date"
    t.integer  "event_start_time", limit: 8
    t.integer  "event_end_time",   limit: 8
  end

  add_index "events", ["apple_id"], name: "index_events_on_apple_id", using: :btree

  create_table "tracks", primary_key: "apple_id", force: :cascade do |t|
    t.string   "artist"
    t.string   "label"
    t.string   "isrc"
    t.string   "vendor_id"
    t.string   "vendor_offer_code"
    t.datetime "created_at",        default: '2015-05-23 16:18:24', null: false
    t.datetime "updated_at",        default: '2015-05-23 16:18:24', null: false
    t.string   "title"
  end

  add_index "tracks", ["label"], name: "index_tracks_on_label", using: :btree

end
