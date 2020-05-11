# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_11_125608) do

  create_table "sakes", force: :cascade do |t|
    t.string "name"
    t.string "kura"
    t.binary "photo"
    t.datetime "bindume"
    t.datetime "by"
    t.string "product_of"
    t.integer "taste_int"
    t.integer "aroma_int"
    t.integer "sake_metre_value"
    t.integer "acidity"
    t.text "aroma_text"
    t.string "color"
    t.text "taste_text"
    t.boolean "is_namadume"
    t.boolean "is_namacho"
    t.string "nigori"
    t.string "awa"
    t.string "tokutei_meisho"
    t.string "genryoumai"
    t.string "kakemai"
    t.string "koubo"
    t.integer "alcohol"
    t.integer "amino_acid"
    t.string "aged"
    t.boolean "is_genshu"
    t.string "moto"
    t.integer "rice_polishing"
    t.string "roka"
    t.string "shibori"
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
