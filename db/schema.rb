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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111112182235) do

  create_table "acos", :force => true do |t|
    t.integer "parent_id"
    t.string  "model"
    t.integer "foreign_key"
    t.string  "alias"
    t.integer "lft"
    t.integer "rght"
  end

  add_index "acos", ["foreign_key"], :name => "foreign_key"
  add_index "acos", ["foreign_key"], :name => "foreign_key_2"

  create_table "addresses", :force => true do |t|
    t.string   "street01",  :limit => 45
    t.string   "street02",  :limit => 45
    t.string   "city",      :limit => 45
    t.string   "state",     :limit => 45
    t.string   "zip",       :limit => 45
    t.string   "country",   :limit => 45
    t.string   "latitude",  :limit => 45
    t.string   "longitude", :limit => 45
    t.integer  "user_id"
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "active",                  :default => false
  end

  add_index "addresses", ["user_id"], :name => "user_id"

  create_table "alerts", :force => true do |t|
    t.string "name", :limit => 100, :null => false
  end

  create_table "alerts_users", :force => true do |t|
    t.integer  "alert_id",                                     :null => false
    t.integer  "user_id"
    t.integer  "goal_id"
    t.string   "status",   :limit => 20, :default => "active", :null => false
    t.datetime "created",                                      :null => false
  end

  create_table "alerts_users_attributes", :force => true do |t|
    t.integer "alerts_users_id",                :null => false
    t.string  "key",             :limit => 100, :null => false
    t.string  "value",           :limit => 50,  :null => false
  end

  create_table "answers", :force => true do |t|
    t.integer "score"
    t.integer "score_cards_criteria_id"
    t.integer "call_detail_id"
    t.integer "marker_position"
    t.integer "user_id"
  end

  create_table "aros", :force => true do |t|
    t.integer "parent_id"
    t.string  "model"
    t.integer "foreign_key"
    t.string  "alias"
    t.integer "lft"
    t.integer "rght"
  end

  add_index "aros", ["foreign_key"], :name => "foreign_key"
  add_index "aros", ["foreign_key"], :name => "foreign_key_2"

  create_table "aros_acos", :force => true do |t|
    t.integer "aro_id",                                :null => false
    t.integer "aco_id",                                :null => false
    t.string  "_create", :limit => 2, :default => "0", :null => false
    t.string  "_read",   :limit => 2, :default => "0", :null => false
    t.string  "_update", :limit => 2, :default => "0", :null => false
    t.string  "_delete", :limit => 2, :default => "0", :null => false
  end

  add_index "aros_acos", ["aro_id", "aco_id"], :name => "ARO_ACO_KEY", :unique => true

  create_table "audio_files", :force => true do |t|
    t.integer  "call_detail_id"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billings", :force => true do |t|
    t.integer "organizational_unit_id",                                :null => false
    t.integer "included_minutes"
    t.integer "used_minutes",                           :default => 0, :null => false
    t.integer "minute_overage_allowed",  :limit => 1,   :default => 0, :null => false
    t.integer "included_users"
    t.string  "billing_type",            :limit => 100
    t.date    "subscription_expiration",                               :null => false
    t.integer "pro_score_quantity",                     :default => 0, :null => false
  end

  create_table "billings_types", :force => true do |t|
    t.string "type", :limit => 100, :null => false
  end

  create_table "cake_sessions", :force => true do |t|
    t.text    "data"
    t.integer "expires"
  end

  create_table "call_detail_notes", :force => true do |t|
    t.integer  "call_detail_id"
    t.string   "name",           :limit => 45
    t.text     "comments"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",         :limit => 20, :default => "active", :null => false
  end

  add_index "call_detail_notes", ["call_detail_id"], :name => "call_detail_id"

  create_table "call_details", :force => true do |t|
    t.string   "external_id",            :limit => 100
    t.string   "title",                  :limit => 100
    t.integer  "user_id"
    t.integer  "organizational_unit_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "ani_type",               :limit => 10
    t.string   "caller_id",              :limit => 50
    t.string   "source",                 :limit => 80
    t.string   "destination",            :limit => 80
    t.string   "destination_channel",    :limit => 80
    t.integer  "is_outbound",                           :default => 0,        :null => false
    t.string   "last_application"
    t.string   "last_data"
    t.integer  "duration"
    t.integer  "bill_seconds"
    t.string   "disposition",            :limit => 32
    t.string   "user_field"
    t.string   "session_id",             :limit => 100
    t.string   "monitored_file_name"
    t.integer  "provisioned_route_id"
    t.string   "target_number",          :limit => 80
    t.string   "account_code",           :limit => 20
    t.integer  "score_card_id"
    t.integer  "scorer_user_id"
    t.integer  "reviewer_user_id"
    t.datetime "scored_date"
    t.datetime "reviewed_date"
    t.float    "final_grade"
    t.boolean  "outcome"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20,  :default => "active", :null => false
  end

  add_index "call_details", ["destination"], :name => "destination"
  add_index "call_details", ["target_number"], :name => "target"

  create_table "call_details_keywords", :id => false, :force => true do |t|
    t.integer "call_detail_id", :null => false
    t.integer "keyword_id",     :null => false
  end

  add_index "call_details_keywords", ["call_detail_id"], :name => "call_detail_id"
  add_index "call_details_keywords", ["keyword_id"], :name => "keyword_id"

  create_table "call_routes", :force => true do |t|
    t.integer  "provisioned_number_id"
    t.integer  "phone_number_id"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                :limit => 20, :default => "active", :null => false
  end

  add_index "call_routes", ["phone_number_id"], :name => "phone_number_id"
  add_index "call_routes", ["provisioned_number_id"], :name => "provisioned_number_id"

  create_table "calls", :force => true do |t|
    t.string   "appID",                         :limit => 45
    t.string   "start_date_time",               :limit => 45
    t.string   "end_date_time",                 :limit => 45
    t.string   "sessionID",                     :limit => 45
    t.string   "ani_call_type",                 :limit => 45
    t.string   "origin_phone_area_code",        :limit => 45
    t.string   "origin_phone_prefix",           :limit => 45
    t.string   "origin_phone_suffix",           :limit => 45
    t.string   "terminating_phone_area_code",   :limit => 45
    t.string   "terminating_phone_prefix",      :limit => 45
    t.string   "terminating_phone_suffix",      :limit => 45
    t.string   "call_duration",                 :limit => 45
    t.string   "call_billing_duration",         :limit => 45
    t.string   "session_type",                  :limit => 45
    t.string   "total_call_duration",           :limit => 45
    t.string   "total_call_billing_duration",   :limit => 45
    t.string   "call_exit_reason",              :limit => 45
    t.string   "xfer_sequence",                 :limit => 45
    t.string   "xfer_destination_phone_number", :limit => 45
    t.string   "xfer_result",                   :limit => 45
    t.string   "xfer_duration",                 :limit => 45
    t.string   "xfer_billing_duration",         :limit => 45
    t.string   "recording_flag",                :limit => 45
    t.string   "destination_context",           :limit => 45
    t.string   "destination_channel",           :limit => 45
    t.string   "last_app",                      :limit => 45
    t.string   "last_data",                     :limit => 45
    t.string   "account_code",                  :limit => 45
    t.string   "user_field",                    :limit => 45
    t.string   "ama_flags",                     :limit => 45
    t.string   "provisioned_number_id",         :limit => 45
    t.string   "recording_id",                  :limit => 45
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "active",                                      :default => false
  end

  create_table "chargify_components", :force => true do |t|
    t.string  "name",        :limit => 150, :null => false
    t.integer "chargify_id",                :null => false
  end

  create_table "chargify_products", :force => true do |t|
    t.string   "name",        :limit => 45
    t.string   "chargify_id", :limit => 20,                        :null => false
    t.string   "renewal",     :limit => 20, :default => "monthly", :null => false
    t.datetime "created",                                          :null => false
    t.datetime "updated",                                          :null => false
    t.string   "status",      :limit => 20, :default => "active",  :null => false
  end

  create_table "chargify_products_components", :id => false, :force => true do |t|
    t.integer "subscription_id",               :null => false
    t.integer "component_id",                  :null => false
    t.integer "default_quantity", :limit => 2, :null => false
    t.integer "display_order",    :limit => 2, :null => false
  end

  create_table "chargify_products_components_organizational_units", :force => true do |t|
    t.integer "chargify_products_component_id", :null => false
    t.integer "organizational_unit_id",         :null => false
    t.integer "quantity",                       :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "external_id"
    t.integer  "call_detail_id",                                          :null => false
    t.integer  "question_id"
    t.integer  "recording_timestamp"
    t.integer  "answer_id"
    t.integer  "user_id"
    t.text     "comment"
    t.boolean  "public"
    t.datetime "created",                                                 :null => false
    t.string   "status",              :limit => 20, :default => "active", :null => false
  end

  create_table "components", :force => true do |t|
    t.string  "name",        :limit => 150, :null => false
    t.integer "chargify_id",                :null => false
  end

  create_table "configuration_sets", :force => true do |t|
    t.integer  "name"
    t.string   "color",         :limit => 45
    t.string   "font",          :limit => 45
    t.string   "logo",          :limit => 45
    t.string   "pricing",       :limit => 45
    t.integer  "sales_unit_id"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",        :limit => 20, :default => "active", :null => false
  end

  add_index "configuration_sets", ["sales_unit_id"], :name => "sales_unit_id"

  create_table "custom_email_templates", :force => true do |t|
    t.integer "organizational_unit_id",                :null => false
    t.string  "template_name",          :limit => 200, :null => false
  end

  create_table "goal_attributes", :force => true do |t|
    t.integer "goal_id",               :null => false
    t.string  "key",     :limit => 55, :null => false
    t.string  "value",   :limit => 55, :null => false
  end

  create_table "goals", :force => true do |t|
    t.integer  "organizational_unit_id",                                     :null => false
    t.integer  "user_id",                                                    :null => false
    t.string   "name",                   :limit => 45
    t.string   "dates",                  :limit => 15,                       :null => false
    t.string   "goal_type",              :limit => 55,                       :null => false
    t.float    "goal_value",                                                 :null => false
    t.integer  "completed",                            :default => 0,        :null => false
    t.integer  "percent_complete",                     :default => 0,        :null => false
    t.integer  "is_front_page",                        :default => 0,        :null => false
    t.string   "status",                 :limit => 15, :default => "active", :null => false
    t.datetime "created",                                                    :null => false
  end

  create_table "google_analytics", :force => true do |t|
    t.text     "postback"
    t.integer  "enabled",                :default => 1
    t.datetime "created",                               :null => false
    t.datetime "modified",                              :null => false
    t.integer  "organizational_unit_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",     :limit => 100, :null => false
    t.integer  "lft"
    t.integer  "rght"
    t.datetime "created"
    t.datetime "modified"
  end

  create_table "groups_old", :force => true do |t|
    t.string   "name",     :limit => 45
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "active",                 :default => false
  end

  create_table "industries", :force => true do |t|
    t.string   "name",                   :limit => 45
    t.integer  "organizational_unit_id"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
  end

  create_table "keywords", :force => true do |t|
    t.integer  "user_id",                                                    :null => false
    t.integer  "organizational_unit_id",                                     :null => false
    t.string   "name",                   :limit => 45
    t.boolean  "public",                                                     :null => false
    t.datetime "created"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
  end

  add_index "keywords", ["public"], :name => "call_detail_id"

  create_table "logs", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.string   "model",       :limit => 40, :null => false
    t.string   "action",      :limit => 40, :null => false
    t.string   "description",               :null => false
    t.string   "title",       :limit => 40, :null => false
    t.datetime "created",                   :null => false
  end

  create_table "mobile_providers", :force => true do |t|
    t.string "name",        :limit => 100, :null => false
    t.string "sms_address", :limit => 100, :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organizational_unit_id"
    t.string   "notify_type",            :limit => 25,                        :null => false
    t.integer  "unread_count",                          :default => 0,        :null => false
    t.string   "message",                :limit => 500,                       :null => false
    t.integer  "starts",                 :limit => 8
    t.integer  "expires",                :limit => 8
    t.integer  "persistent",                            :default => 0,        :null => false
    t.string   "status",                 :limit => 20,  :default => "active", :null => false
    t.datetime "created",                                                     :null => false
  end

  create_table "notifications_statuses", :force => true do |t|
    t.integer  "notification_id", :null => false
    t.integer  "user_id"
    t.datetime "created",         :null => false
  end

  create_table "npanxx_082011", :id => false, :force => true do |t|
    t.string "NPA",              :limit => 3,                    :null => false
    t.string "NXX",              :limit => 3,                    :null => false
    t.string "BLOCK_ID",         :limit => 1,                    :null => false
    t.string "TBP_IND",          :limit => 1
    t.string "LATA",             :limit => 5
    t.string "LTYPE",            :limit => 1
    t.string "CONTAM",           :limit => 1
    t.string "STATE",            :limit => 2
    t.string "COUNTRY",          :limit => 2
    t.string "WC",               :limit => 128
    t.string "SWITCH",           :limit => 11
    t.string "RCSTATUS",         :limit => 2
    t.string "RCTYPE",           :limit => 1
    t.string "RC",               :limit => 10
    t.string "TZ",               :limit => 2
    t.string "DST",              :limit => 1
    t.string "ZIP",              :limit => 5
    t.string "ZIP2",             :limit => 5
    t.string "ZIP3",             :limit => 5
    t.string "ZIP4",             :limit => 5
    t.string "FIPS",             :limit => 5
    t.string "FIPS2",            :limit => 5
    t.string "FIPS3",            :limit => 5
    t.string "CBSA",             :limit => 5
    t.string "CBSA2",            :limit => 5
    t.string "MSA",              :limit => 4
    t.string "PMSA",             :limit => 4
    t.float  "LATITUDE",                        :default => 0.0, :null => false
    t.float  "LONGITUDE",                       :default => 0.0, :null => false
    t.string "OCN_CATEGORY",     :limit => 1
    t.string "OCN",              :limit => 4
    t.string "DERIVED_FROM_NPA", :limit => 3
    t.string "NEWNPA",           :limit => 20
    t.string "OVERLAY",          :limit => 1
  end

  create_table "npanxxgeo", :id => false, :force => true do |t|
    t.string  "NPA",                :limit => 3
    t.string  "NXX",                :limit => 3
    t.string  "STATION_CODE_LOW",   :limit => 4
    t.string  "STATION_CODE_HIGH",  :limit => 4
    t.string  "COUNTRY",            :limit => 2
    t.string  "STATE",              :limit => 2
    t.string  "CITY",               :limit => 35
    t.string  "COUNTY",             :limit => 25
    t.decimal "LATITUDE",                          :precision => 9, :scale => 6
    t.decimal "LONGITUDE",                         :precision => 9, :scale => 6
    t.string  "LATA",               :limit => 3
    t.string  "TIMEZONE",           :limit => 4
    t.string  "OBSERVES_DST",       :limit => 1
    t.string  "COUNTY_POPULATION",  :limit => 8
    t.string  "FIPS_COUNTY_CODE",   :limit => 5
    t.integer "MSA_COUNTY_CODE",    :limit => 2
    t.integer "PMSA_COUNTY_CODE",   :limit => 2
    t.integer "CBSA_COUNTY_CODE",   :limit => 2
    t.string  "ZIPCODE_POSTALCODE", :limit => 7
    t.string  "ZIPCODE_COUNT",      :limit => 4
    t.string  "ZIPCODE_FREQUENCY",  :limit => 4
    t.string  "NEW_NPA",            :limit => 3
    t.string  "NXX_USE_TYPE",       :limit => 1
    t.date    "NXX_INTRO_VERSION"
    t.string  "OVERLAY",            :limit => 1
    t.string  "OCN",                :limit => 4
    t.string  "COMPANY",            :limit => 50
    t.string  "RATE_CENTER",        :limit => 30
    t.string  "SWITCH_CLLI",        :limit => 18
    t.string  "RC_VERTICAL",        :limit => 5
    t.string  "RC_HORIZONTAL",      :limit => 5
    t.integer "lonlat",             :limit => nil,                               :null => false
  end

  add_index "npanxxgeo", ["NPA", "NXX", "RATE_CENTER", "lonlat"], :name => "NPA_2", :length => {"NPA"=>nil, "NXX"=>nil, "RATE_CENTER"=>nil, "lonlat"=>"25"}
  add_index "npanxxgeo", ["NPA"], :name => "NPA"
  add_index "npanxxgeo", ["NXX"], :name => "NXX"
  add_index "npanxxgeo", ["ZIPCODE_POSTALCODE", "NXX_USE_TYPE", "RATE_CENTER"], :name => "ZIPCODE_POSTALCODE"
  add_index "npanxxgeo", ["lonlat"], :name => "lonlat", :length => {"lonlat"=>"32"}

  create_table "npanxxsmall", :force => true do |t|
    t.string "npanxx",  :limit => 10,  :null => false
    t.string "city",    :limit => 200, :null => false
    t.string "county",  :limit => 200, :null => false
    t.string "state",   :limit => 10,  :null => false
    t.string "zipcode", :limit => 15,  :null => false
  end

  add_index "npanxxsmall", ["npanxx"], :name => "npanxx"

  create_table "npanxxzip", :id => false, :force => true do |t|
    t.string "NPA",   :limit => 3,   :null => false
    t.string "NXX",   :limit => 3,   :null => false
    t.string "ZIP",   :limit => 5,   :null => false
    t.string "STATE", :limit => 2,   :null => false
    t.string "CITY",  :limit => 128, :null => false
    t.string "RC",    :limit => 10,  :null => false
  end

  add_index "npanxxzip", ["NPA", "NXX", "ZIP"], :name => "npanxxzip"

  create_table "organizational_units", :force => true do |t|
    t.integer  "external_id"
    t.string   "zoho_id",              :limit => 45
    t.string   "name",                 :limit => 45
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city",                 :limit => 45
    t.string   "state",                :limit => 45
    t.string   "zip",                  :limit => 45
    t.integer  "is_store",                            :default => 0,          :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.text     "api_key"
    t.string   "api_secret",           :limit => 100
    t.string   "phone_number",         :limit => 45
    t.integer  "configuration_set_id"
    t.integer  "sales_unit_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rght"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",               :limit => 20,  :default => "inactive", :null => false
    t.boolean  "master_node",                         :default => false
    t.integer  "chargify_product_id"
  end

  create_table "permissions", :force => true do |t|
    t.string "title",       :limit => 100
    t.string "description"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer "permission_id", :null => false
    t.integer "user_id",       :null => false
  end

  create_table "phone_number_provisioned_routes", :id => false, :force => true do |t|
    t.integer "phone_number_id",      :null => false
    t.integer "provisioned_route_id", :null => false
  end

  create_table "phone_number_types", :force => true do |t|
    t.string "name", :limit => 45
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer  "organizational_unit_id",                                     :null => false
    t.string   "number",                 :limit => 45
    t.integer  "type"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
    t.integer  "provisioned_route_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",  :null => false
    t.string   "title",    :null => false
    t.text     "body"
    t.datetime "created"
    t.datetime "modified"
  end

  create_table "prices", :force => true do |t|
    t.string   "name",       :limit => 45
    t.float    "value"
    t.string   "default",    :limit => 45
    t.datetime "created"
    t.datetime "modified"
    t.integer  "product_id"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                   :limit => 45
    t.string   "description",            :limit => 45
    t.string   "quantity",               :limit => 45
    t.integer  "organizational_unit_id"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_privacy",                       :default => 0
    t.integer  "tag_privacy",                           :default => 0
    t.string   "language",                :limit => 50, :default => "English", :null => false
    t.integer  "time_zone_id"
    t.integer  "rows_per_page",                         :default => 10,        :null => false
    t.integer  "session_timeout",                       :default => 15,        :null => false
    t.integer  "is_scorer",               :limit => 2,  :default => 0,         :null => false
    t.string   "notification_preference", :limit => 50, :default => "email",   :null => false
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "profiles", ["user_id"], :name => "user_id"

  create_table "providers", :force => true do |t|
    t.string   "name",          :limit => 45
    t.float    "inbound_cost"
    t.float    "outbound_cost"
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "active",                      :default => false
  end

  create_table "provisioned_numbers", :force => true do |t|
    t.integer  "organizational_unit_id"
    t.string   "name",                   :limit => 45
    t.string   "phone_number_id",        :limit => 45
    t.string   "provider_id",            :limit => 45
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "active",                               :default => false
  end

  create_table "provisioned_routes", :force => true do |t|
    t.integer  "organizational_unit_id"
    t.string   "name",                   :limit => 45
    t.string   "description",            :limit => 45
    t.integer  "provider_id"
    t.integer  "product_id"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
    t.boolean  "play_disclaimer",                      :default => true,     :null => false
    t.integer  "play_branding",                        :default => 1,        :null => false
  end

  add_index "provisioned_routes", ["organizational_unit_id"], :name => "organizational_unit_id"
  add_index "provisioned_routes", ["product_id"], :name => "product_id"
  add_index "provisioned_routes", ["provider_id"], :name => "provider_id"

  create_table "questions", :force => true do |t|
    t.integer "score_card_id"
    t.integer "weight"
    t.text    "question"
  end

  create_table "recordings", :force => true do |t|
    t.integer  "organizational_unit_id"
    t.string   "file_name"
    t.string   "type",                   :limit => 45
    t.integer  "call_detail_id"
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
  end

  add_index "recordings", ["call_detail_id"], :name => "call_detail_id"

  create_table "recordings_users", :id => false, :force => true do |t|
    t.integer "recording_id", :null => false
    t.integer "user_id",      :null => false
  end

  create_table "report_refine_boxes", :force => true do |t|
    t.integer "report_id",                :null => false
    t.string  "model",     :limit => 200, :null => false
  end

  create_table "reports", :force => true do |t|
    t.string "name",      :limit => 250,                         :null => false
    t.string "file_name", :limit => 250,                         :null => false
    t.string "status",    :limit => 20,  :default => "inactive", :null => false
  end

  create_table "responses", :force => true do |t|
    t.integer  "comment_id",                                     :null => false
    t.text     "response"
    t.integer  "user_id",                                        :null => false
    t.datetime "created",                                        :null => false
    t.string   "status",     :limit => 20, :default => "active", :null => false
  end

  add_index "responses", ["comment_id"], :name => "comment_id"
  add_index "responses", ["user_id"], :name => "user_id"

  create_table "routes", :id => false, :force => true do |t|
    t.integer "provisioned_route_id"
    t.string  "dnis",                 :limit => 45
    t.string  "ring_to_number",       :limit => 45
  end

  create_table "routing_table", :id => false, :force => true do |t|
    t.integer "route_id"
    t.string  "dnis",           :limit => 45
    t.string  "ring_to_number", :limit => 45
  end

  create_table "sales_units", :force => true do |t|
    t.integer  "organizational_unit_id"
    t.string   "name",                   :limit => 45
    t.datetime "created"
    t.datetime "modified"
    t.string   "status",                 :limit => 20, :default => "active", :null => false
  end

  create_table "score_cards", :force => true do |t|
    t.integer "organizational_unit_id"
    t.string  "name",                   :limit => 45
    t.text    "description"
    t.string  "outcome_label",          :limit => 45,                         :null => false
    t.integer "scorecard_importance",                                         :null => false
    t.string  "status",                 :limit => 20, :default => "inactive", :null => false
  end

  create_table "score_cards_criterias", :force => true do |t|
    t.integer "score_card_id",                :null => false
    t.string  "title",         :limit => 100, :null => false
    t.string  "type",          :limit => 20,  :null => false
    t.string  "help_text",     :limit => 250, :null => false
    t.integer "importance",                   :null => false
    t.integer "order",                        :null => false
    t.integer "required",                     :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.string "name", :limit => 45
  end

  create_table "subscriptions_components", :id => false, :force => true do |t|
    t.integer "subscription_id",               :null => false
    t.integer "component_id",                  :null => false
    t.integer "default_quantity", :limit => 2, :null => false
    t.integer "display_order",    :limit => 2, :null => false
  end

  create_table "teleclicks", :force => true do |t|
    t.string "name", :limit => 45
  end

  create_table "teleclicks_schedules", :force => true do |t|
    t.integer  "provisioned_route_id",                               :null => false
    t.integer  "day",                                                :null => false
    t.string   "start",                :limit => 10,                 :null => false
    t.string   "end",                  :limit => 10,                 :null => false
    t.integer  "timezone",                           :default => -7, :null => false
    t.datetime "created",                                            :null => false
    t.datetime "modified",                                           :null => false
  end

  add_index "teleclicks_schedules", ["id"], :name => "id", :unique => true

  create_table "test_suite_articles", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.string   "title",                                   :null => false
    t.text     "body"
    t.string   "published", :limit => 1, :default => "N"
    t.datetime "created"
    t.datetime "updated"
  end

  create_table "test_suite_articles_tags", :id => false, :force => true do |t|
    t.integer "article_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "test_suite_articles_tags", ["article_id", "tag_id"], :name => "UNIQUE_TAG", :unique => true

  create_table "test_suite_category_threads", :force => true do |t|
    t.integer  "parent_id", :null => false
    t.string   "name",      :null => false
    t.datetime "created"
    t.datetime "updated"
  end

  create_table "test_suite_comments", :force => true do |t|
    t.integer  "article_id",                               :null => false
    t.integer  "user_id",                                  :null => false
    t.text     "comment"
    t.string   "published",  :limit => 1, :default => "N"
    t.datetime "created"
    t.datetime "updated"
  end

  create_table "test_suite_posts", :force => true do |t|
    t.integer  "author_id",                               :null => false
    t.string   "title",                                   :null => false
    t.text     "body"
    t.string   "published", :limit => 1, :default => "N"
    t.datetime "created"
    t.datetime "updated"
  end

  create_table "test_suite_tags", :force => true do |t|
    t.string   "tag",     :null => false
    t.datetime "created"
    t.datetime "updated"
  end

  create_table "test_suite_test_plugin_comments", :force => true do |t|
    t.integer  "article_id",                               :null => false
    t.integer  "user_id",                                  :null => false
    t.text     "comment"
    t.string   "published",  :limit => 1, :default => "N"
    t.datetime "created"
    t.datetime "updated"
  end

  create_table "time_zones", :force => true do |t|
    t.string  "name",         :limit => 50, :null => false
    t.string  "abbreviation", :limit => 10, :null => false
    t.integer "utc",          :limit => 2,  :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "external_id"
    t.string   "username",                                                    :null => false
    t.string   "password",               :limit => 40,                        :null => false
    t.string   "first_name",             :limit => 45
    t.string   "last_name",              :limit => 45
    t.string   "title",                  :limit => 50
    t.integer  "group_id",                                                    :null => false
    t.integer  "organizational_unit_id"
    t.string   "primary_phone",          :limit => 45
    t.string   "mobile_phone",           :limit => 100
    t.integer  "mobile_provider_id"
    t.datetime "modified"
    t.datetime "created"
    t.string   "status",                 :limit => 20,  :default => "active", :null => false
  end

  add_index "users", ["group_id"], :name => "group_id"
  add_index "users", ["organizational_unit_id"], :name => "organizational_unit_id"
  add_index "users", ["username"], :name => "username", :unique => true

  create_table "users_old", :force => true do |t|
    t.integer  "group_id"
    t.string   "email",                  :limit => 45
    t.string   "password",               :limit => 45
    t.string   "first_name",             :limit => 45
    t.string   "last_name",              :limit => 45
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "active",                               :default => false
    t.integer  "parent_id"
    t.integer  "phone_number_id"
    t.integer  "address_id"
    t.integer  "organizational_unit_id"
    t.string   "user_name",                                               :null => false
  end

  add_index "users_old", ["group_id"], :name => "group_id"
  add_index "users_old", ["organizational_unit_id"], :name => "organizational_unit_id"

  create_table "widgets", :force => true do |t|
    t.string  "name",     :limit => 100, :null => false
    t.string  "part_no",  :limit => 12
    t.integer "quantity"
  end

end
