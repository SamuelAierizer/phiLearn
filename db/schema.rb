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

ActiveRecord::Schema.define(version: 2022_02_14_062852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "answer_given"
    t.integer "answers_type"
    t.decimal "mark_achieved"
    t.integer "solution_id"
    t.string "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
  end

  create_table "assignments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "assignment_type"
    t.datetime "deadline"
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.index ["course_id"], name: "index_assignments_on_course_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "target_type"
    t.integer "target_id"
    t.integer "parent_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.integer "like_count"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image_path"
    t.integer "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.index ["name"], name: "index_courses_on_name", unique: true
    t.index ["owner_id"], name: "index_courses_on_owner_id"
  end

  create_table "forums", force: :cascade do |t|
    t.integer "forumable_id"
    t.integer "forumable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
  end

  create_table "group_posts", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "group_id"
    t.integer "post_type"
    t.integer "like_count"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "access_code"
    t.integer "group_type"
    t.integer "created_by"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lectures", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.index ["course_id"], name: "index_lectures_on_course_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "likeable_id"
    t.integer "likeable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "likeable_id", "likeable_type"], name: "index_likes_on_user_id_and_likeable_id_and_likeable_type", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer "uid"
    t.integer "memable_id"
    t.integer "memable_type"
    t.integer "mem_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "notif_type"
    t.string "message"
    t.integer "status"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.integer "topic_id"
    t.integer "user_id"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "like_count", default: 0
    t.datetime "deleted_at", precision: 6
  end

  create_table "profiles", force: :cascade do |t|
    t.text "about"
    t.string "address"
    t.string "phone"
    t.integer "status"
    t.string "public_src"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cover_photo"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "question_options", force: :cascade do |t|
    t.string "value"
    t.integer "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "correct"
    t.datetime "deleted_at", precision: 6
  end

  create_table "questions", force: :cascade do |t|
    t.string "question_asked"
    t.string "answer"
    t.integer "question_type"
    t.decimal "mark_available"
    t.integer "assignment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.index ["assignment_id"], name: "index_questions_on_assignment_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.integer "material_type"
    t.integer "material_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "school_forum", default: false
    t.boolean "course_forum", default: false
    t.datetime "deleted_at", precision: 6
    t.index ["name"], name: "index_schools_on_name", unique: true
  end

  create_table "solutions", force: :cascade do |t|
    t.decimal "grade"
    t.string "file"
    t.integer "user_id"
    t.integer "assignment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "course_id"
    t.datetime "deleted_at", precision: 6
    t.index ["assignment_id"], name: "index_solutions_on_assignment_id"
    t.index ["course_id"], name: "index_solutions_on_course_id"
    t.index ["user_id", "assignment_id"], name: "index_solutions_on_user_id_and_assignment_id", unique: true
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_students_on_course_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "last_poster"
    t.datetime "last_post_at"
    t.integer "forum_id"
    t.integer "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_blocked", default: false
    t.datetime "deleted_at", precision: 6
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.integer "role"
    t.string "profile_picture"
    t.integer "school_id"
    t.datetime "deleted_at", precision: 6
    t.index ["email", "school_id"], name: "index_users_on_email_and_school_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
    t.index ["username", "school_id"], name: "index_users_on_username_and_school_id", unique: true
  end

  add_foreign_key "comments", "users"
end
