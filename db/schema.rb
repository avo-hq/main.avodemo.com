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

ActiveRecord::Schema[8.1].define(version: 2026_06_17_190548) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "avo_collaboration_actions", force: :cascade do |t|
    t.string "batch_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "new_value"
    t.string "old_value"
    t.string "property"
    t.datetime "updated_at", null: false
  end

  create_table "avo_collaboration_comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "avo_collaboration_entries", force: :cascade do |t|
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at", null: false
    t.integer "entryable_id"
    t.string "entryable_type"
    t.integer "target_id"
    t.string "target_type"
    t.datetime "updated_at", null: false
  end

  create_table "avo_collaboration_reactions", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.string "emoji"
    t.datetime "updated_at", null: false
  end

  create_table "avo_kanban_boards", force: :cascade do |t|
    t.integer "columns_count", default: 0
    t.datetime "created_at", null: false
    t.integer "items_count", default: 0
    t.string "name"
    t.jsonb "settings"
    t.datetime "updated_at", null: false
  end

  create_table "avo_kanban_columns", force: :cascade do |t|
    t.bigint "board_id"
    t.datetime "created_at", null: false
    t.integer "items_count", default: 0
    t.string "name"
    t.integer "position"
    t.jsonb "settings"
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_avo_kanban_columns_on_board_id"
  end

  create_table "avo_kanban_items", force: :cascade do |t|
    t.bigint "board_id"
    t.bigint "column_id"
    t.datetime "created_at", null: false
    t.integer "position"
    t.bigint "record_id"
    t.string "record_type"
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_avo_kanban_items_on_board_id"
    t.index ["column_id"], name: "index_avo_kanban_items_on_column_id"
    t.index ["record_type", "record_id"], name: "index_avo_kanban_items_on_record"
  end

  create_table "avo_notifications_notifications", force: :cascade do |t|
    t.text "body"
    t.json "buttons"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.integer "level", default: 0, null: false
    t.datetime "marked_as_done_at"
    t.string "notification_type"
    t.datetime "read_at"
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.datetime "saved_at"
    t.bigint "sender_id"
    t.string "sender_type"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["created_at"], name: "index_avo_notifications_notifications_on_created_at"
    t.index ["expires_at"], name: "index_avo_notifications_notifications_on_expires_at"
    t.index ["level"], name: "index_avo_notifications_notifications_on_level"
    t.index ["marked_as_done_at"], name: "index_avo_notifications_notifications_on_marked_as_done_at"
    t.index ["read_at"], name: "index_avo_notifications_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_avo_notifications_notifications_on_recipient"
    t.index ["saved_at"], name: "index_avo_notifications_notifications_on_saved_at"
    t.index ["sender_type", "sender_id"], name: "index_avo_notifications_notifications_on_sender"
  end

  create_table "cities", force: :cascade do |t|
    t.json "city_center_area"
    t.datetime "created_at", null: false
    t.json "features"
    t.string "image_url"
    t.boolean "is_capital"
    t.float "latitude"
    t.float "longitude"
    t.json "metadata"
    t.string "name"
    t.integer "population"
    t.string "status"
    t.text "tiny_description"
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "course_links", force: :cascade do |t|
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.string "link"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_links_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "name"
    t.text "skills", default: [], array: true
    t.datetime "updated_at", null: false
  end

  create_table "db_config_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "eager_load", default: false, null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.string "value_type", default: "String", null: false
    t.index ["eager_load"], name: "index_db_config_records_on_eager_load"
    t.index ["key"], name: "index_db_config_records_on_key", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "event_time"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "fish", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_fish_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "number"
    t.string "priority"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "person_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["person_id"], name: "index_people_on_person_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.boolean "is_featured"
    t.string "name"
    t.datetime "published_at", precision: nil
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "budget"
    t.string "country"
    t.datetime "created_at", null: false
    t.text "description"
    t.json "meta"
    t.string "name"
    t.integer "progress"
    t.string "stage"
    t.datetime "started_at", precision: nil
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "users_required"
  end

  create_table "projects_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "project_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.string "branch"
    t.datetime "created_at", null: false
    t.boolean "draft", default: false
    t.integer "number"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "rails_comments_comments", force: :cascade do |t|
    t.string "author_id"
    t.string "author_type"
    t.text "body"
    t.string "commentable_id", null: false
    t.string "commentable_type", null: false
    t.datetime "created_at", null: false
    t.string "parent_id"
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "reviewable_id"
    t.string "reviewable_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.string "taggable_type"
    t.bigint "tagger_id"
    t.string "tagger_type"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "taggings_count", default: 0
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "assignee"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_on"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "team_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level"
    t.bigint "team_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.date "birthday"
    t.datetime "created_at", null: false
    t.text "custom_css"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.json "roles"
    t.string "slug"
    t.bigint "team_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users"
  add_foreign_key "fish", "users"
  add_foreign_key "people", "people"
  add_foreign_key "people", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
end
