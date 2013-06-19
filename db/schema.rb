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

ActiveRecord::Schema.define(:version => 20130619195818) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "artist_genres", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "genre_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "artists", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.string   "booking"
    t.string   "username"
    t.string   "slug"
    t.string   "name"
    t.string   "email"
    t.string   "url"
    t.string   "tel"
    t.text     "description"
  end

  add_index "artists", ["slug"], :name => "index_artists_on_slug"

  create_table "artists_gigs", :id => false, :force => true do |t|
    t.integer "artist_id"
    t.integer "gig_id"
  end

  create_table "authentications", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "permissions"
    t.integer  "user_id"
    t.text     "raw"
    t.string   "credentials"
    t.string   "expired_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gigs", :force => true do |t|
    t.string   "title"
    t.datetime "starts_at"
    t.time     "duration"
    t.string   "admission"
    t.string   "url"
    t.string   "email"
    t.text     "description"
    t.integer  "venue_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "creator_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "group_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "page_settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "page_name"
    t.string   "page_id"
    t.text     "page_token"
    t.string   "category"
    t.text     "perms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "profile_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "page_id"
    t.string   "selected"
    t.text     "token"
    t.string   "user_id"
    t.string   "category"
    t.text     "perms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.string   "user_name"
    t.string   "website_url"
    t.integer  "rating"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "provider"
    t.string   "uid"
    t.text     "bio"
    t.string   "remote_avatar_url"
    t.string   "phone"
    t.string   "gender"
    t.datetime "confirmed_at"
    t.text     "address"
    t.integer  "artist_id"
    t.integer  "page_id"
    t.integer  "user_id"
    t.string   "selected_page_id"
    t.string   "selected_group_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  create_table "publish_histories", :force => true do |t|
    t.integer  "gig_id"
    t.string   "provider"
    t.datetime "posted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schedule_posts", :force => true do |t|
    t.integer  "gig_id"
    t.integer  "user_id"
    t.boolean  "post_facebook",      :default => false
    t.boolean  "post_twitter",       :default => false
    t.boolean  "post_immediately",   :default => false
    t.boolean  "post_a_week_before", :default => false
    t.boolean  "post_a_day_before",  :default => false
    t.boolean  "post_the_day_off",   :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.decimal  "lat",         :precision => 15, :scale => 10
    t.decimal  "lng",         :precision => 15, :scale => 10
    t.string   "name"
    t.integer  "country_id"
    t.text     "description"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "tel"
    t.string   "url"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "country"
  end

end
