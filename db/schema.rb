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

ActiveRecord::Schema.define(version: 20181030165153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.decimal "price", precision: 15, scale: 2
    t.integer "inventory_count", default: 0
    t.text "description"
    t.string "img_url", default: "http://equip2clean.co.uk/media/catalog/product/cache/4/image/500x600/9df78eab33525d08d6e5fb8d27136e95/placeholder/default/placeholder.jpg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "order_id"
    t.integer "item_quantity"
    t.decimal "item_price", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fulfilled", default: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip_code"
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_img_url", default: "https://www.psgdental.com/wp-content/uploads/2017/04/default-placeholder.jpg"
  end

  add_foreign_key "items", "users"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
end
