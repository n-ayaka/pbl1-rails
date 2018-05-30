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

ActiveRecord::Schema.define(version: 2018_05_30_004829) do

  create_table "attendances", primary_key: "att_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "uid", null: false
    t.date "date", null: false
    t.integer "att1"
    t.integer "att2"
    t.integer "att3"
    t.integer "att4"
    t.integer "att5"
    t.datetime "att_time"
    t.datetime "go_back_time"
  end

  create_table "fl_days", primary_key: "school_year", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "first1"
    t.date "last1"
    t.date "first2"
    t.date "last2"
    t.date "first3"
    t.date "last3"
  end

  create_table "histories", primary_key: "history_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "uid", null: false
    t.string "table_name", null: false
    t.integer "table_id", null: false
    t.datetime "history_time", null: false
    t.string "status", null: false
  end

  create_table "images", primary_key: "image_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "uid", null: false
    t.datetime "image_time", null: false
    t.string "image", null: false
  end

  create_table "school_days", primary_key: "date", id: :date, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "school_flag", default: false, null: false
  end

  create_table "users", primary_key: "uid", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "school_year", null: false
    t.string "user_id", null: false
    t.string "user_name", null: false
    t.string "password", null: false
  end

end
