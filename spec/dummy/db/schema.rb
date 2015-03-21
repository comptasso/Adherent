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

ActiveRecord::Schema.define(version: 20150321054651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adherent_adhesions", force: true do |t|
    t.date     "from_date"
    t.date     "to_date"
    t.decimal  "amount",     precision: 10, scale: 2
    t.integer  "member_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "adherent_adhesions", ["member_id"], name: "index_adherent_adhesions_on_member_id", using: :btree

  create_table "adherent_coords", force: true do |t|
    t.string   "mail"
    t.string   "tel"
    t.string   "gsm"
    t.string   "office"
    t.text     "address"
    t.string   "zip"
    t.string   "city"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adherent_members", force: true do |t|
    t.string   "number"
    t.string   "name"
    t.string   "forname"
    t.date     "birthdate"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "organism_id"
  end

  create_table "adherent_payments", force: true do |t|
    t.date     "date"
    t.decimal  "amount",     precision: 10, scale: 2
    t.string   "mode"
    t.integer  "member_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "comment"
  end

  add_index "adherent_payments", ["member_id"], name: "index_adherent_payments_on_member_id", using: :btree

  create_table "adherent_reglements", force: true do |t|
    t.decimal  "amount",      precision: 10, scale: 2
    t.integer  "adhesion_id"
    t.integer  "payment_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "adherent_reglements", ["adhesion_id"], name: "index_adherent_reglements_on_adhesion_id", using: :btree
  add_index "adherent_reglements", ["payment_id"], name: "index_adherent_reglements_on_payment_id", using: :btree

  create_table "organisms", force: true do |t|
    t.string   "title"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
