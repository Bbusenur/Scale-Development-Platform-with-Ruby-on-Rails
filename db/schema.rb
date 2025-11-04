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

ActiveRecord::Schema[8.0].define(version: 2025_11_02_112904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.string "analysis_type", null: false
    t.string "status", default: "Queued", null: false
    t.jsonb "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_analyses_on_status"
    t.index ["survey_id"], name: "index_analyses_on_survey_id"
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.integer "cost"
    t.string "activity_type"
    t.datetime "transaction_date"
    t.integer "reference_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "text", null: false
    t.string "question_type", default: "text"
    t.bigint "survey_id", null: false
    t.integer "order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_questions_on_survey_id"
  end

  create_table "responses", force: :cascade do |t|
    t.string "participant_id"
    t.jsonb "raw_data"
    t.bigint "survey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_responses_on_survey_id"
  end

  create_table "scales", force: :cascade do |t|
    t.string "unique_scale_id"
    t.string "title"
    t.string "version"
    t.datetime "last_validated_at"
    t.boolean "is_public"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "scale_type"
    t.text "description"
    t.index ["user_id"], name: "index_scales_on_user_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.string "distribution_mode"
    t.boolean "is_mobile_friendly"
    t.bigint "scale_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scale_id"], name: "index_surveys_on_scale_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "forename"
    t.string "surname"
    t.string "hashed_password"
    t.integer "credit_balance"
    t.string "role"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "analyses", "surveys"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "questions", "surveys"
  add_foreign_key "responses", "surveys"
  add_foreign_key "scales", "users"
  add_foreign_key "surveys", "scales"
end
