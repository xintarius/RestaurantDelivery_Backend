# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_10_145956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "location_id"
    t.bigint "user_id"
    t.string "city"
    t.string "postal_code"
    t.string "postal_city"
    t.string "street"
    t.string "building"
    t.string "apartment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_addresses_on_location_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.date "date"
    t.integer "weekday"
    t.string "timeline_nr"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_calendars_on_date", unique: true
  end

  create_table "cart_products", force: :cascade do |t|
    t.bigint "cart_summary_id"
    t.bigint "product_id"
    t.integer "quantity"
    t.integer "unit_price"
    t.integer "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_summary_id"], name: "index_cart_products_on_cart_summary_id"
    t.index ["product_id"], name: "index_cart_products_on_product_id"
  end

  create_table "cart_summaries", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.integer "gross_payment"
    t.integer "net_payment"
    t.decimal "vat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_cart_summaries_on_order_id"
    t.index ["user_id"], name: "index_cart_summaries_on_user_id"
  end

  create_table "courier_orders", force: :cascade do |t|
    t.bigint "courier_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["courier_id", "order_id"], name: "index_courier_orders_on_courier_id_and_order_id", unique: true
    t.index ["courier_id"], name: "index_courier_orders_on_courier_id"
    t.index ["order_id"], name: "index_courier_orders_on_order_id"
  end

  create_table "courier_payment_daily_aggregates", force: :cascade do |t|
    t.bigint "calendars_id"
    t.bigint "courier_id"
    t.integer "delivery_count", default: 0
    t.decimal "sum_gross", precision: 10, scale: 2
    t.decimal "sum_net", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendars_id"], name: "index_courier_payment_daily_aggregates_on_calendars_id"
    t.index ["courier_id", "calendars_id"], name: "idx_on_courier_id_calendars_id_021615db87", unique: true
    t.index ["courier_id"], name: "index_courier_payment_daily_aggregates_on_courier_id"
  end

  create_table "courier_payments", force: :cascade do |t|
    t.bigint "courier_id"
    t.bigint "courier_trace_id"
    t.integer "gross_payment"
    t.integer "net_payment"
    t.decimal "vat"
    t.string "kilometer_distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "orders_id"
    t.bigint "order_id"
    t.index ["courier_id"], name: "index_courier_payments_on_courier_id"
    t.index ["courier_trace_id"], name: "index_courier_payments_on_courier_trace_id"
    t.index ["order_id"], name: "index_courier_payments_on_order_id"
    t.index ["orders_id"], name: "index_courier_payments_on_orders_id"
  end

  create_table "courier_traces", force: :cascade do |t|
    t.bigint "courier_id"
    t.bigint "vendor_id"
    t.bigint "order_id"
    t.string "trace_from_start"
    t.string "trace_to_collect_order"
    t.string "trace_from_vendor"
    t.string "trace_to_client"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["courier_id"], name: "index_courier_traces_on_courier_id"
    t.index ["order_id"], name: "index_courier_traces_on_order_id"
    t.index ["vendor_id"], name: "index_courier_traces_on_vendor_id"
  end

  create_table "couriers", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "addresses_id"
    t.bigint "locations_id"
    t.bigint "roles_id"
    t.string "courier_status", default: "Offline"
    t.string "courier_code"
    t.string "vehicle_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["addresses_id"], name: "index_couriers_on_addresses_id"
    t.index ["locations_id"], name: "index_couriers_on_locations_id"
    t.index ["roles_id"], name: "index_couriers_on_roles_id"
    t.index ["user_id"], name: "index_couriers_on_user_id"
    t.index ["users_id"], name: "index_couriers_on_users_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "region_name"
    t.string "longitude"
    t.string "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notification_users_on_notification_id"
    t.index ["user_id"], name: "index_notification_users_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "sender"
    t.datetime "received_date"
    t.boolean "read", default: false
  end

  create_table "order_products", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "product_id"
    t.integer "quantity"
    t.integer "unit_price"
    t.integer "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "user_id"
    t.string "order_status", default: "pending"
    t.string "order_note_vendor"
    t.string "order_note_courier"
    t.string "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.index ["vendor_id"], name: "index_orders_on_vendor_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "vendor_id"
    t.string "product_name"
    t.integer "amount", default: 1
    t.decimal "price_gross"
    t.decimal "price_net"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_path"
    t.string "description"
    t.index ["vendor_id"], name: "index_products_on_vendor_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.bigint "products_id"
    t.string "promo_value_reduction"
    t.string "promo_value_vendor_reduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["products_id"], name: "index_promotions_on_products_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "couriers_id"
    t.bigint "products_id"
    t.bigint "vendors_id"
    t.string "description"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["couriers_id"], name: "index_reviews_on_couriers_id"
    t.index ["products_id"], name: "index_reviews_on_products_id"
    t.index ["users_id"], name: "index_reviews_on_users_id"
    t.index ["vendors_id"], name: "index_reviews_on_vendors_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terminal_calendars", force: :cascade do |t|
    t.bigint "terminal_id"
    t.bigint "calendars_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendars_id"], name: "index_terminal_calendars_on_calendars_id"
    t.index ["terminal_id"], name: "index_terminal_calendars_on_terminal_id"
  end

  create_table "terminals", force: :cascade do |t|
    t.time "hour_from"
    t.time "hour_to"
    t.integer "courier_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_payments", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "prace_per_order"
    t.integer "gross_payment"
    t.integer "net_payment"
    t.decimal "vat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id"
    t.string "username"
    t.string "phone_number"
    t.string "stripe_customer_id"
    t.string "stripe_payment_method_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "vendor_payments", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "order_id"
    t.integer "price_per_order"
    t.integer "gross_payment"
    t.integer "net_payment"
    t.decimal "vat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_vendor_payments_on_order_id"
    t.index ["vendor_id"], name: "index_vendor_payments_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.bigint "address_id"
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_path"
    t.string "description"
    t.string "nip"
    t.boolean "activated_in_system", default: false
    t.index ["address_id"], name: "index_vendors_on_address_id"
    t.index ["user_id"], name: "index_vendors_on_user_id"
  end

  add_foreign_key "addresses", "locations"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_products", "cart_summaries"
  add_foreign_key "cart_products", "products"
  add_foreign_key "cart_summaries", "orders"
  add_foreign_key "cart_summaries", "users"
  add_foreign_key "courier_orders", "couriers"
  add_foreign_key "courier_orders", "orders"
  add_foreign_key "courier_payment_daily_aggregates", "calendars", column: "calendars_id"
  add_foreign_key "courier_payment_daily_aggregates", "couriers"
  add_foreign_key "courier_payments", "courier_traces"
  add_foreign_key "courier_payments", "couriers"
  add_foreign_key "courier_payments", "orders"
  add_foreign_key "courier_payments", "orders", column: "orders_id"
  add_foreign_key "courier_traces", "couriers"
  add_foreign_key "courier_traces", "orders"
  add_foreign_key "courier_traces", "vendors"
  add_foreign_key "couriers", "addresses", column: "addresses_id"
  add_foreign_key "couriers", "locations", column: "locations_id"
  add_foreign_key "couriers", "roles", column: "roles_id"
  add_foreign_key "couriers", "users"
  add_foreign_key "couriers", "users", column: "users_id"
  add_foreign_key "notification_users", "notifications"
  add_foreign_key "notification_users", "users"
  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "vendors"
  add_foreign_key "products", "vendors"
  add_foreign_key "reviews", "couriers", column: "couriers_id"
  add_foreign_key "reviews", "products", column: "products_id"
  add_foreign_key "reviews", "users", column: "users_id"
  add_foreign_key "reviews", "vendors", column: "vendors_id"
  add_foreign_key "terminal_calendars", "calendars", column: "calendars_id"
  add_foreign_key "terminal_calendars", "terminals"
  add_foreign_key "user_payments", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "vendor_payments", "orders"
  add_foreign_key "vendor_payments", "vendors"
  add_foreign_key "vendors", "addresses"
  add_foreign_key "vendors", "users"
end
