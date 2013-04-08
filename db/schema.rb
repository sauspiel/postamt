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

ActiveRecord::Schema.define(version: 20130408112535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_stat_statements"

  create_table "accounting_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "delta"
    t.string   "comment"
    t.integer  "before"
    t.integer  "after"
    t.boolean  "serious",      default: false, null: false
    t.boolean  "internal",     default: true,  null: false
    t.datetime "created_at"
    t.integer  "balance_type", default: 0,     null: false
  end

  add_index "accounting_entries", ["user_id", "serious", "after"], name: "accounting_entries_user_fk", using: :btree

  create_table "announcements", force: true do |t|
    t.text     "message"
    t.string   "user_associations"
    t.string   "user_conditions"
    t.datetime "valid_from"
    t.datetime "valid_until"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.boolean  "condolence",        default: false
  end

  create_table "auth_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "client"
    t.string   "aasm_state"
    t.string   "client_info"
    t.string   "ip_address"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "auth_tokens", ["token"], name: "index_auth_tokens_on_token", using: :btree
  add_index "auth_tokens", ["user_id"], name: "index_auth_tokens_on_user_id", using: :btree

  create_table "avatars", force: true do |t|
    t.integer "user_id"
    t.string  "gender",         limit: 6
    t.integer "body"
    t.integer "top"
    t.integer "body_id"
    t.string  "body_color"
    t.integer "trousers_id"
    t.string  "trousers_color"
    t.integer "head_id"
    t.integer "hair_id"
    t.string  "hair_color"
    t.integer "eyes_id"
    t.string  "eyes_color"
    t.integer "brows_id"
    t.string  "brows_color"
    t.integer "nose_id"
    t.integer "mouth_id"
    t.string  "mouth_color"
    t.integer "shirt_id"
    t.string  "shirt_color"
    t.integer "extras_id"
    t.integer "voice_id",                 default: 1
  end

  add_index "avatars", ["user_id"], name: "avatars_user_fk", unique: true, using: :btree

  create_table "bank_account_blacklists", force: true do |t|
    t.string   "bank_number",     limit: 10
    t.string   "bank_name"
    t.string   "account_number",  limit: 20
    t.string   "iban"
    t.string   "bic"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bank_account_id"
  end

  create_table "bank_account_versions", force: true do |t|
    t.integer  "bank_account_id"
    t.integer  "version"
    t.integer  "user_id"
    t.string   "holder_name"
    t.string   "bank_number",     limit: 8
    t.string   "bank_name"
    t.string   "account_number",  limit: 20
    t.string   "iban"
    t.string   "bic"
    t.boolean  "active",                     default: false
    t.boolean  "validated"
    t.boolean  "action_required",            default: true
    t.string   "state"
    t.integer  "problem_count"
    t.datetime "updated_at"
  end

  create_table "bank_accounts", force: true do |t|
    t.integer "user_id"
    t.string  "holder_name"
    t.string  "bank_number",     limit: 8
    t.string  "bank_name"
    t.string  "account_number",  limit: 20
    t.string  "iban"
    t.string  "bic"
    t.boolean "active",                     default: false, null: false
    t.boolean "validated"
    t.boolean "action_required",            default: true,  null: false
    t.string  "state"
    t.integer "problem_count"
    t.integer "version"
  end

  add_index "bank_accounts", ["user_id"], name: "bank_account_user_fk", unique: true, using: :btree

  create_table "blocked_actions", force: true do |t|
    t.integer  "user_id"
    t.integer  "user_computer_id"
    t.string   "email"
    t.string   "action"
    t.text     "message"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blocked_ip_addresses", force: true do |t|
    t.string   "address",         limit: 15
    t.string   "state",           limit: 20
    t.string   "comment"
    t.integer  "signup_attempts",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blocked_ip_addresses", ["state"], name: "index_blocked_ip_addresses_on_state", using: :btree

  create_table "blog_posts", force: true do |t|
    t.integer  "author_id"
    t.string   "title"
    t.text     "body"
    t.text     "extended_body"
    t.boolean  "published"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "commentable",   default: true
  end

  create_table "booking_groups", force: true do |t|
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: true do |t|
    t.integer  "bookable_id",                          null: false
    t.string   "bookable_type",                        null: false
    t.string   "account_number",           limit: 100, null: false
    t.string   "bank_number",              limit: 100, null: false
    t.string   "holder_name",              limit: 250, null: false
    t.string   "bank_name",                limit: 250, null: false
    t.integer  "price",                                null: false
    t.string   "direction",                            null: false
    t.date     "timestamp",                            null: false
    t.string   "key",                      limit: 10
    t.string   "text",                     limit: 250, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "booking_group_id"
    t.integer  "booking_group_filenumber"
    t.string   "iban"
    t.string   "bic"
    t.string   "payment_method"
  end

  create_table "cash_games", force: true do |t|
    t.integer  "table_id"
    t.integer  "game_at_table_id"
    t.integer  "first_position",   limit: 2
    t.boolean  "played",                                 null: false
    t.integer  "game_type_id",     limit: 2
    t.string   "suit",             limit: 1
    t.boolean  "won"
    t.integer  "points",           limit: 2
    t.integer  "price",                      default: 0
    t.integer  "rake",                       default: 0
    t.integer  "price_for_winner",           default: 0
    t.boolean  "announcement"
    t.integer  "result",           limit: 2
    t.integer  "runners",          limit: 2
    t.integer  "knockings",        limit: 2
    t.integer  "contras",          limit: 2
    t.boolean  "short_deck"
    t.integer  "balance_type",     limit: 2
    t.integer  "rate_id",                    default: 0
    t.integer  "player_id"
    t.integer  "partner1_id"
    t.integer  "partner2_id"
    t.integer  "partner3_id"
    t.datetime "created_at"
  end

  add_index "cash_games", ["partner1_id", "created_at"], name: "index_partner1_created", using: :btree
  add_index "cash_games", ["partner2_id", "created_at"], name: "index_partner2_created", using: :btree
  add_index "cash_games", ["partner3_id", "created_at"], name: "index_partner3_created", using: :btree
  add_index "cash_games", ["player_id", "created_at"], name: "index_player_created", using: :btree

  create_table "chat_messages", force: true do |t|
    t.string   "message"
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "table_id"
    t.datetime "created_at", null: false
  end

  add_index "chat_messages", ["table_id", "created_at"], name: "index_chat_messages_on_game_id", using: :btree
  add_index "chat_messages", ["user_id"], name: "index_chat_messages_on_user_id", using: :btree

  create_table "collusions", force: true do |t|
    t.string   "state"
    t.integer  "user_id"
    t.integer  "partner_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collusions", ["partner_id"], name: "index_collusions_on_partner_id", using: :btree
  add_index "collusions", ["user_id", "partner_id"], name: "index_collusions_on_user_id_and_partner_id", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.datetime "created_at",                               null: false
    t.integer  "commentable_id",              default: 0,  null: false
    t.string   "commentable_type", limit: 15, default: "", null: false
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "comments_user_fk", using: :btree

  create_table "contact_requests", force: true do |t|
    t.string   "subject"
    t.string   "email"
    t.string   "name"
    t.text     "message"
    t.string   "short_info"
    t.string   "additional_info"
    t.string   "ip"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "number"
    t.string   "card_type"
    t.string   "expiry_month"
    t.string   "expiry_year"
    t.string   "storage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_rankings", force: true do |t|
    t.integer "user_id"
    t.integer "balance_type"
    t.date    "start_of_period"
    t.integer "games_played"
    t.integer "gain"
    t.integer "gain_per_game"
    t.integer "wenz_won"
    t.integer "solo_won"
    t.integer "tout_won"
    t.integer "high_score",          default: 0, null: false
    t.integer "games_as_player",     default: 0, null: false
    t.integer "games_as_partner",    default: 0, null: false
    t.integer "games_as_enemy",      default: 0, null: false
    t.integer "sauspiel_won",        default: 0, null: false
    t.integer "wenz_tout_won",       default: 0, null: false
    t.integer "solo_tout_won",       default: 0, null: false
    t.integer "sauspiel_announced",  default: 0, null: false
    t.integer "wenz_announced",      default: 0, null: false
    t.integer "solo_announced",      default: 0, null: false
    t.integer "wenz_tout_announced", default: 0, null: false
    t.integer "solo_tout_announced", default: 0, null: false
    t.integer "sie_announced",       default: 0, null: false
    t.integer "knockings",           default: 0, null: false
    t.integer "kontra",              default: 0, null: false
    t.integer "re",                  default: 0, null: false
    t.integer "current_score",       default: 0, null: false
    t.integer "farbwenz_announced",  default: 0, null: false
    t.integer "farbwenz_won",        default: 0, null: false
    t.integer "geier_announced",     default: 0, null: false
    t.integer "geier_won",           default: 0, null: false
    t.integer "short_played",        default: 0, null: false
    t.integer "dirty_played",        default: 0, null: false
  end

  add_index "daily_rankings", ["start_of_period", "gain"], name: "index_daily_rankings_on_start_of_period_and_gain", using: :btree
  add_index "daily_rankings", ["start_of_period", "gain_per_game"], name: "index_daily_rankings_on_start_of_period_and_gain_per_game", using: :btree
  add_index "daily_rankings", ["start_of_period", "games_played"], name: "index_daily_rankings_on_start_of_period_and_games_played", using: :btree
  add_index "daily_rankings", ["start_of_period", "solo_won"], name: "index_daily_rankings_on_start_of_period_and_solo_won", using: :btree
  add_index "daily_rankings", ["start_of_period", "tout_won"], name: "index_daily_rankings_on_start_of_period_and_tout_won", using: :btree
  add_index "daily_rankings", ["start_of_period", "wenz_won"], name: "index_daily_rankings_on_start_of_period_and_wenz_won", using: :btree
  add_index "daily_rankings", ["user_id", "balance_type", "start_of_period"], name: "daily_lookup_index", using: :btree
  add_index "daily_rankings", ["user_id"], name: "index_daily_rankings_on_user_id", using: :btree

  create_table "daily_winners", force: true do |t|
    t.integer  "table_id"
    t.integer  "game_at_table_id"
    t.integer  "first_position",   limit: 2
    t.boolean  "played",                                 null: false
    t.integer  "game_type_id",     limit: 2
    t.string   "suit",             limit: 1
    t.boolean  "won"
    t.integer  "points",           limit: 2
    t.integer  "price",                      default: 0
    t.integer  "rake",                       default: 0
    t.integer  "price_for_winner",           default: 0
    t.boolean  "announcement"
    t.integer  "result",           limit: 2
    t.integer  "runners",          limit: 2
    t.integer  "knockings",        limit: 2
    t.integer  "contras",          limit: 2
    t.boolean  "short_deck"
    t.integer  "balance_type",     limit: 2
    t.integer  "rate_id",                    default: 0
    t.integer  "player_id"
    t.integer  "partner1_id"
    t.integer  "partner2_id"
    t.integer  "partner3_id"
    t.datetime "created_at"
  end

  add_index "daily_winners", ["created_at"], name: "created_at", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "klass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "index_delayed_jobs_on_priority_and_run_at", using: :btree

  create_table "dispositions", force: true do |t|
    t.string  "merchant_transaction_id"
    t.integer "amount"
    t.string  "currency"
    t.string  "state"
  end

  create_table "email_rejections", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "email_rejections", ["email", "state"], name: "index_email_rejections_on_email_and_state", using: :btree
  add_index "email_rejections", ["user_id", "state"], name: "index_email_rejections_on_user_id_and_state", using: :btree

  create_table "eternal_rankings", force: true do |t|
    t.integer "user_id"
    t.integer "balance_type"
    t.integer "games_played",                                    default: 0,   null: false
    t.integer "gain",                                            default: 0,   null: false
    t.float   "gain_per_game",                                   default: 0.0, null: false
    t.integer "wenz_won",                                        default: 0,   null: false
    t.integer "solo_won",                                        default: 0,   null: false
    t.integer "tout_won",                                        default: 0,   null: false
    t.integer "high_score",                                      default: 0,   null: false
    t.integer "games_as_player",                                 default: 0,   null: false
    t.integer "games_as_partner",                                default: 0,   null: false
    t.integer "games_as_enemy",                                  default: 0,   null: false
    t.integer "sauspiel_won",                                    default: 0,   null: false
    t.integer "wenz_tout_won",                                   default: 0,   null: false
    t.integer "solo_tout_won",                                   default: 0,   null: false
    t.integer "sauspiel_announced",                              default: 0,   null: false
    t.integer "wenz_announced",                                  default: 0,   null: false
    t.integer "solo_announced",                                  default: 0,   null: false
    t.integer "wenz_tout_announced",                             default: 0,   null: false
    t.integer "solo_tout_announced",                             default: 0,   null: false
    t.integer "sie_announced",                                   default: 0,   null: false
    t.integer "knockings",                                       default: 0,   null: false
    t.integer "kontra",                                          default: 0,   null: false
    t.integer "re",                                              default: 0,   null: false
    t.integer "current_score",                                   default: 0,   null: false
    t.integer "farbwenz_announced",                              default: 0,   null: false
    t.integer "geier_announced",                                 default: 0,   null: false
    t.integer "farbwenz_won",                                    default: 0,   null: false
    t.integer "geier_won",                                       default: 0,   null: false
    t.integer "short_played",                                    default: 0,   null: false
    t.integer "dirty_played",                                    default: 0,   null: false
    t.decimal "skill_both",            precision: 12, scale: 10
    t.decimal "skill_deviation_both",  precision: 12, scale: 10
    t.decimal "skill_short",           precision: 12, scale: 10
    t.decimal "skill_deviation_short", precision: 12, scale: 10
    t.decimal "skill_long",            precision: 12, scale: 10
    t.decimal "skill_deviation_long",  precision: 12, scale: 10
  end

  add_index "eternal_rankings", ["current_score"], name: "index_eternal_rankings_on_current_score", using: :btree
  add_index "eternal_rankings", ["gain"], name: "index_eternal_rankings_on_gain", using: :btree
  add_index "eternal_rankings", ["gain_per_game"], name: "index_eternal_rankings_on_gain_per_game", using: :btree
  add_index "eternal_rankings", ["games_played"], name: "index_eternal_rankings_on_games_played", using: :btree
  add_index "eternal_rankings", ["high_score"], name: "index_eternal_rankings_on_high_score", using: :btree
  add_index "eternal_rankings", ["sauspiel_won"], name: "index_eternal_rankings_on_sauspiel_won", using: :btree
  add_index "eternal_rankings", ["sie_announced"], name: "index_eternal_rankings_on_sie_announced", using: :btree
  add_index "eternal_rankings", ["solo_tout_won"], name: "index_eternal_rankings_on_solo_tout_won", using: :btree
  add_index "eternal_rankings", ["solo_won"], name: "index_eternal_rankings_on_solo_won", using: :btree
  add_index "eternal_rankings", ["tout_won"], name: "index_eternal_rankings_on_tout_won", using: :btree
  add_index "eternal_rankings", ["user_id", "balance_type"], name: "eternal_lookup_index", using: :btree
  add_index "eternal_rankings", ["user_id"], name: "eternal_rankings_user_fk", using: :btree
  add_index "eternal_rankings", ["wenz_tout_won"], name: "index_eternal_rankings_on_wenz_tout_won", using: :btree
  add_index "eternal_rankings", ["wenz_won"], name: "index_eternal_rankings_on_wenz_won", using: :btree

  create_table "event_participations", force: true do |t|
    t.integer  "event_id",                          null: false
    t.integer  "user_id",                           null: false
    t.string   "state",      default: "registered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_participations", ["event_id", "user_id"], name: "event_participants_user_event", unique: true, using: :btree
  add_index "event_participations", ["user_id"], name: "event_participants_user_fk", using: :btree

  create_table "event_photos", force: true do |t|
    t.string   "title"
    t.string   "description",        limit: 1024
    t.integer  "user_id"
    t.integer  "event_id",                        null: false
    t.string   "image_file_name",                 null: false
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_photos", ["event_id"], name: "index_event_photos_on_event_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title"
    t.datetime "start_date",                                             null: false
    t.string   "state",                              default: "pending"
    t.integer  "official",                                               null: false
    t.integer  "creator_id",                                             null: false
    t.text     "description"
    t.integer  "max_participants"
    t.integer  "min_participants"
    t.integer  "buyin"
    t.integer  "location_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.boolean  "public",                             default: true
    t.boolean  "tournament",                         default: false
    t.string   "tournament_attributes", limit: 1000
    t.boolean  "online_registration",                default: false
    t.boolean  "internal_registration",              default: false
    t.string   "image_file_name"
  end

  add_index "events", ["creator_id"], name: "events_creator_fk", using: :btree
  add_index "events", ["group_id"], name: "events_groups_fk", using: :btree
  add_index "events", ["location_id"], name: "events_location_fk", using: :btree

  create_table "facebook_users", force: true do |t|
    t.integer  "user_id"
    t.string   "facebook_id"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_games", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.string   "title",      limit: 100
    t.integer  "position",               default: 0, null: false
  end

  add_index "favorite_games", ["game_id"], name: "favorite_games_game_fk", using: :btree
  add_index "favorite_games", ["user_id", "game_id"], name: "index_favorite_games_on_user_id_and_game_id", unique: true, using: :btree

  create_table "forum_categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "forum_discussions_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                 default: true
  end

  create_table "forum_discussion_watches", force: true do |t|
    t.integer  "user_id"
    t.integer  "forum_discussion_id"
    t.integer  "forum_message_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_discussion_watches", ["user_id"], name: "index_forum_discussion_watches_on_user_id", using: :btree

  create_table "forum_discussions", force: true do |t|
    t.integer  "user_id"
    t.integer  "forum_category_id"
    t.string   "subject"
    t.string   "state",                           default: "published"
    t.integer  "forum_messages_count",            default: 0
    t.integer  "last_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.boolean  "public",                          default: true
    t.integer  "message_including_deleted_count", default: 0
  end

  add_index "forum_discussions", ["group_id"], name: "forum_discussions_groups_fk", using: :btree

  create_table "forum_messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "forum_discussion_id"
    t.text     "message"
    t.string   "state",               default: "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_messages", ["forum_discussion_id"], name: "index_forum_messages_on_forum_discussion_id", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "confirmation_id"
    t.datetime "created_at"
  end

  add_index "friendships", ["confirmation_id"], name: "friendships_confirmation_fk", using: :btree
  add_index "friendships", ["friend_id"], name: "friendships_friend_fk", using: :btree
  add_index "friendships", ["user_id", "confirmation_id", "friend_id"], name: "friendships_user_confirmation_friend", unique: true, using: :btree
  add_index "friendships", ["user_id", "friend_id"], name: "friendships_user_friend_unique", unique: true, using: :btree

  create_table "game_details", force: true do |t|
    t.integer "game_id"
    t.binary  "position_mapping"
    t.binary  "cards"
    t.binary  "tricks"
    t.binary  "knock_positions"
    t.binary  "contra_positions"
    t.binary  "playing_positions"
    t.binary  "playing_announcements"
  end

  add_index "game_details", ["game_id"], name: "index_game_details_on_game_id", using: :btree

  create_table "game_tables", force: true do |t|
    t.integer  "room",          limit: 2
    t.integer  "rate",          limit: 2
    t.integer  "balance_type",  limit: 2
    t.integer  "num_games",               default: 0
    t.string   "special_rules"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "table_id"
    t.integer  "game_at_table_id"
    t.integer  "first_position",   limit: 2
    t.boolean  "played",                                 null: false
    t.integer  "game_type_id",     limit: 2
    t.string   "suit",             limit: 1
    t.boolean  "won"
    t.integer  "points",           limit: 2
    t.integer  "price",                      default: 0
    t.integer  "rake",                       default: 0
    t.integer  "price_for_winner",           default: 0
    t.boolean  "announcement"
    t.integer  "result",           limit: 2
    t.integer  "runners",          limit: 2
    t.integer  "knockings",        limit: 2
    t.integer  "contras",          limit: 2
    t.boolean  "short_deck"
    t.integer  "balance_type",     limit: 2
    t.integer  "rate_id",                    default: 0
    t.integer  "player_id"
    t.integer  "partner1_id"
    t.integer  "partner2_id"
    t.integer  "partner3_id"
    t.datetime "created_at"
  end

  add_index "games", ["balance_type"], name: "index_games_on_balance_type2", where: "(balance_type = 2)", using: :btree
  add_index "games", ["created_at"], name: "index_games_on_created_at", using: :btree
  add_index "games", ["player_id", "id"], name: "index_games_on_player_id_and_id_where_played", where: "(played AND (price > 0))", using: :btree

  create_table "games_tournaments", force: true do |t|
    t.integer "tournament_id"
    t.integer "game_id"
    t.integer "round",         limit: 2
    t.integer "table_serial",  limit: 2
    t.integer "game_serial",   limit: 2
  end

  add_index "games_tournaments", ["game_id"], name: "index_games_tournaments_on_game_id", using: :btree
  add_index "games_tournaments", ["tournament_id", "round", "table_serial", "game_serial"], name: "by_tournament_round_table_game", using: :btree

  create_table "gift_coupons", force: true do |t|
    t.integer  "redeemer_id"
    t.integer  "issuer_id"
    t.string   "state",         default: "pending"
    t.string   "code"
    t.string   "sent_to"
    t.datetime "redeemed_at"
    t.integer  "coupon_months"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "premium_level", default: 2
  end

  create_table "group_memberships", force: true do |t|
    t.integer  "group_id",                         null: false
    t.integer  "invitor_id"
    t.integer  "user_id",                          null: false
    t.string   "role",         default: "user",    null: false
    t.string   "state",        default: "pending", null: false
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["group_id", "user_id"], name: "index_group_memberships_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_memberships", ["user_id"], name: "group_memberships_users_fk", using: :btree

  create_table "groups", force: true do |t|
    t.string   "title",                                   null: false
    t.text     "description"
    t.string   "image_file_name"
    t.boolean  "public",                   default: true, null: false
    t.boolean  "edit_posts",               default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "active_memberships_count"
    t.datetime "deleted_at"
  end

  create_table "guestbook_entries", force: true do |t|
    t.integer  "author_id",       default: 0,     null: false
    t.integer  "recipient_id",    default: 0,     null: false
    t.text     "comment",                         null: false
    t.datetime "created_at",                      null: false
    t.boolean  "deleted",         default: false, null: false
    t.boolean  "from_hated_user", default: false
    t.integer  "parent_id"
  end

  add_index "guestbook_entries", ["author_id"], name: "guestbook_entries_author_fk", using: :btree
  add_index "guestbook_entries", ["parent_id"], name: "index_guestbook_entries_on_parent_id", using: :btree
  add_index "guestbook_entries", ["recipient_id"], name: "guestbook_entries_recipient_fk", using: :btree

  create_table "hateships", force: true do |t|
    t.integer  "user_id"
    t.integer  "hated_id"
    t.datetime "created_at"
  end

  add_index "hateships", ["hated_id"], name: "hateships_hated_fk", using: :btree
  add_index "hateships", ["user_id", "hated_id"], name: "hateships_user_hated_unique", unique: true, using: :btree

  create_table "help_categories", force: true do |t|
    t.string   "title"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "help_questions", force: true do |t|
    t.integer  "help_category_id"
    t.text     "question"
    t.text     "answer"
    t.string   "tags"
    t.text     "internal_tags"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.text     "internal_conditions"
  end

  create_table "invitations", force: true do |t|
    t.integer  "inviting_user_id"
    t.string   "email"
    t.string   "note"
    t.string   "link_token",       null: false
    t.datetime "created_at",       null: false
    t.datetime "accepted_at"
    t.integer  "invited_user_id"
  end

  add_index "invitations", ["inviting_user_id"], name: "invitations_fk", using: :btree
  add_index "invitations", ["link_token"], name: "invitation_link_token_unique", unique: true, using: :btree

  create_table "locations", force: true do |t|
    t.string   "name",                            null: false
    t.text     "description"
    t.text     "url"
    t.string   "address"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "is_outside",      default: false
    t.boolean  "has_drinks",      default: false
    t.boolean  "has_food",        default: false
    t.boolean  "smoking_allowed", default: false
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "lottery_emails", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_deliveries", force: true do |t|
    t.string   "message_id"
    t.string   "sender_email"
    t.string   "recipient_email"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.string   "state"
    t.integer  "status_code"
    t.string   "status_message"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "mail_deliveries", ["message_id"], name: "index_mail_deliveries_on_message_id", using: :btree
  add_index "mail_deliveries", ["recipient_email"], name: "index_mail_deliveries_on_recipient_email", using: :btree
  add_index "mail_deliveries", ["recipient_id"], name: "index_mail_deliveries_on_recipient_id", using: :btree
  add_index "mail_deliveries", ["status_code"], name: "index_mail_deliveries_on_status_code", using: :btree

  create_table "mailings", force: true do |t|
    t.integer  "newsletter_id"
    t.integer  "user_id"
    t.boolean  "success"
    t.string   "state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "mailings", ["newsletter_id", "success", "user_id"], name: "index_mailings_on_newsletter_id_and_success_and_user_id", using: :btree

  create_table "medias", force: true do |t|
    t.string   "title"
    t.string   "file_file_name"
    t.string   "file_file_size"
    t.string   "file_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memos", force: true do |t|
    t.integer  "author_id"
    t.integer  "recipient_id"
    t.text     "comment"
    t.datetime "created_at"
  end

  add_index "memos", ["author_id", "recipient_id"], name: "hateships_author_recipient_unique", unique: true, using: :btree
  add_index "memos", ["recipient_id"], name: "hateships_recipient_fk", using: :btree

  create_table "money_coupons", force: true do |t|
    t.integer  "creator_id"
    t.integer  "redeemer_id"
    t.string   "state"
    t.integer  "amount"
    t.string   "code"
    t.string   "comment"
    t.string   "prefix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "money_coupons", ["code"], name: "index_money_coupons_on_code", unique: true, using: :btree
  add_index "money_coupons", ["redeemer_id"], name: "index_money_coupons_on_redeemer_id", using: :btree
  add_index "money_coupons", ["state"], name: "index_money_coupons_on_state", using: :btree

  create_table "monthly_rankings", force: true do |t|
    t.integer "user_id"
    t.integer "balance_type"
    t.date    "start_of_period"
    t.integer "games_played",        default: 0,   null: false
    t.integer "gain",                default: 0,   null: false
    t.float   "gain_per_game",       default: 0.0, null: false
    t.integer "wenz_won",            default: 0,   null: false
    t.integer "solo_won",            default: 0,   null: false
    t.integer "tout_won",            default: 0,   null: false
    t.integer "high_score",          default: 0,   null: false
    t.integer "games_as_player",     default: 0,   null: false
    t.integer "games_as_partner",    default: 0,   null: false
    t.integer "games_as_enemy",      default: 0,   null: false
    t.integer "sauspiel_won",        default: 0,   null: false
    t.integer "wenz_tout_won",       default: 0,   null: false
    t.integer "solo_tout_won",       default: 0,   null: false
    t.integer "sauspiel_announced",  default: 0,   null: false
    t.integer "wenz_announced",      default: 0,   null: false
    t.integer "solo_announced",      default: 0,   null: false
    t.integer "wenz_tout_announced", default: 0,   null: false
    t.integer "solo_tout_announced", default: 0,   null: false
    t.integer "sie_announced",       default: 0,   null: false
    t.integer "knockings",           default: 0,   null: false
    t.integer "kontra",              default: 0,   null: false
    t.integer "re",                  default: 0,   null: false
    t.integer "current_score",       default: 0,   null: false
    t.integer "farbwenz_announced",  default: 0,   null: false
    t.integer "geier_announced",     default: 0,   null: false
    t.integer "farbwenz_won",        default: 0,   null: false
    t.integer "geier_won",           default: 0,   null: false
    t.integer "short_played",        default: 0,   null: false
    t.integer "dirty_played",        default: 0,   null: false
  end

  add_index "monthly_rankings", ["start_of_period", "current_score"], name: "index_monthly_rankings_on_start_of_period_and_current_score", using: :btree
  add_index "monthly_rankings", ["start_of_period", "gain"], name: "index_monthly_rankings_on_start_of_period_and_gain", using: :btree
  add_index "monthly_rankings", ["start_of_period", "gain_per_game"], name: "index_monthly_rankings_on_start_of_period_and_gain_per_game", using: :btree
  add_index "monthly_rankings", ["start_of_period", "games_played"], name: "index_monthly_rankings_on_start_of_period_and_games_played", using: :btree
  add_index "monthly_rankings", ["start_of_period", "high_score"], name: "index_monthly_rankings_on_start_of_period_and_high_score", using: :btree
  add_index "monthly_rankings", ["start_of_period", "sauspiel_won"], name: "index_monthly_rankings_on_start_of_period_and_sauspiel_won", using: :btree
  add_index "monthly_rankings", ["start_of_period", "sie_announced"], name: "index_monthly_rankings_on_start_of_period_and_sie_announced", using: :btree
  add_index "monthly_rankings", ["start_of_period", "solo_tout_won"], name: "index_monthly_rankings_on_start_of_period_and_solo_tout_won", using: :btree
  add_index "monthly_rankings", ["start_of_period", "solo_won"], name: "index_monthly_rankings_on_start_of_period_and_solo_won", using: :btree
  add_index "monthly_rankings", ["start_of_period", "tout_won"], name: "index_monthly_rankings_on_start_of_period_and_tout_won", using: :btree
  add_index "monthly_rankings", ["start_of_period", "wenz_tout_won"], name: "index_monthly_rankings_on_start_of_period_and_wenz_tout_won", using: :btree
  add_index "monthly_rankings", ["start_of_period", "wenz_won"], name: "index_monthly_rankings_on_start_of_period_and_wenz_won", using: :btree
  add_index "monthly_rankings", ["user_id", "balance_type", "start_of_period"], name: "monthly_lookup_index", using: :btree
  add_index "monthly_rankings", ["user_id"], name: "monthly_rankings_user_fk", using: :btree

  create_table "newsletters", force: true do |t|
    t.string   "title"
    t.string   "state"
    t.string   "subject"
    t.text     "text"
    t.text     "html"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_templates", force: true do |t|
    t.string   "subject",    null: false
    t.text     "message",    null: false
    t.string   "recipients", null: false
    t.string   "conditions"
    t.string   "joins"
    t.text     "logins"
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.string   "holder_name"
    t.integer  "bank_number",    limit: 8
    t.string   "bank_name"
    t.integer  "account_number", limit: 8
    t.string   "iban"
    t.string   "bic"
    t.integer  "payment_type"
    t.integer  "amount"
    t.string   "confirmation"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                    default: "open"
  end

  create_table "popular_games", force: true do |t|
    t.integer  "user_id",                 null: false
    t.integer  "game_id",                 null: false
    t.integer  "votes_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "premium_accountings", force: true do |t|
    t.integer "user_id"
    t.date    "starts_at"
    t.date    "ends_at"
    t.integer "premium_level"
    t.string  "comment"
    t.boolean "playcards_received", default: false
    t.string  "state"
  end

  add_index "premium_accountings", ["user_id"], name: "premium_accounting_user_fk", using: :btree

  create_table "premium_billings", force: true do |t|
    t.string   "state",                                            null: false
    t.decimal  "price",                   precision: 10, scale: 0, null: false
    t.datetime "paid_until",                                       null: false
    t.string   "payment_method",                                   null: false
    t.text     "payment_info"
    t.integer  "premium_subscription_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "premium_guest_tickets", force: true do |t|
    t.integer "sponsor_id"
    t.integer "user_id"
    t.date    "starts_at"
    t.date    "ends_at"
    t.integer "premium_level", default: 1, null: false
    t.string  "comment"
  end

  add_index "premium_guest_tickets", ["sponsor_id", "starts_at", "ends_at"], name: "guest_ticket_sponsor", using: :btree
  add_index "premium_guest_tickets", ["starts_at", "ends_at"], name: "guest_ticket_time", using: :btree
  add_index "premium_guest_tickets", ["user_id", "starts_at", "ends_at"], name: "guest_ticket_user", using: :btree

  create_table "premium_membership_addons", force: true do |t|
    t.integer  "premium_membership_id"
    t.string   "premium_membership_type"
    t.integer  "monthly_price"
    t.string   "name"
    t.string   "display_name"
    t.text     "data"
    t.string   "booking_text_modifier"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "premium_subscriptions", force: true do |t|
    t.string   "state",                      null: false
    t.integer  "level",                      null: false
    t.string   "payment_method",             null: false
    t.string   "period",         limit: 100, null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ends_at"
  end

  create_table "prepaid_premium_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "premium_level",  default: 2
    t.string   "state",          default: "pending"
    t.string   "code"
    t.datetime "activated_at"
    t.integer  "prepaid_months"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_messages", force: true do |t|
    t.integer  "author_id"
    t.integer  "recipient_id"
    t.datetime "sent_at"
    t.datetime "read_at"
    t.string   "subject",           limit: 200
    t.text     "body"
    t.boolean  "deleted_author",                default: false
    t.boolean  "deleted_recipient",             default: false
    t.boolean  "answered",                      default: false, null: false
    t.string   "author_type"
    t.integer  "thread_id"
  end

  add_index "private_messages", ["author_id"], name: "private_messages_author_fk", using: :btree
  add_index "private_messages", ["recipient_id"], name: "private_messages_recipient_fk", using: :btree
  add_index "private_messages", ["thread_id"], name: "index_private_messages_on_thread_id", using: :btree

  create_table "profile_visits", force: true do |t|
    t.integer  "profile_id"
    t.integer  "visitor_id"
    t.datetime "last_visited_at"
    t.integer  "counter"
  end

  add_index "profile_visits", ["profile_id", "last_visited_at"], name: "profile_last_visit", using: :btree
  add_index "profile_visits", ["profile_id", "visitor_id"], name: "profile_visits_profile_fk", using: :btree
  add_index "profile_visits", ["visitor_id"], name: "profile_visits_visitor_fk", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id",                                        default: 0,     null: false
    t.string   "avatar"
    t.text     "about"
    t.datetime "announcement_read_at"
    t.integer  "balance_play",                                   default: 0,     null: false
    t.integer  "balance_premium",                                default: 0,     null: false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "show_on_map",                                    default: false
    t.integer  "premium_level",                        limit: 2, default: 0
    t.datetime "premium_until"
    t.boolean  "show_birthday",                                  default: true
    t.boolean  "user_search_with_last_name_and_email",           default: true
    t.string   "image_file_name"
  end

  add_index "profiles", ["user_id"], name: "profiles_user_fk", unique: true, using: :btree

  create_table "rake_transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "tournament_id"
    t.integer  "amount"
    t.integer  "rake"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rake_transactions", ["game_id"], name: "index_rake_transactions_on_game_id", using: :btree

  create_table "rates", force: true do |t|
    t.integer  "room_id"
    t.integer  "base_rate"
    t.integer  "solo_rate"
    t.integer  "rake",             default: 0
    t.integer  "minimum"
    t.boolean  "knocking_allowed"
    t.boolean  "is_default",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refills", force: true do |t|
    t.integer  "user_id"
    t.integer  "balance_type"
    t.integer  "old_balance"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refills", ["user_id", "balance_type"], name: "refills_on_user_id_and_balance_type", using: :btree

  create_table "renames", force: true do |t|
    t.integer  "user_id"
    t.string   "attribute_field"
    t.string   "value"
    t.string   "state"
    t.string   "confirmation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_value"
  end

  create_table "reportable_cache", force: true do |t|
    t.string   "model_name",       limit: 100,                                        null: false
    t.string   "report_name",      limit: 100,                                        null: false
    t.string   "grouping",         limit: 10,                                         null: false
    t.string   "aggregation",      limit: 10,                                         null: false
    t.string   "conditions",       limit: 100,                                        null: false
    t.decimal  "value",                        precision: 32, scale: 5, default: 0.0, null: false
    t.datetime "reporting_period",                                                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reportable_cache", ["model_name", "report_name", "grouping", "aggregation", "conditions", "reporting_period"], name: "name_model_grouping_aggregation_period", unique: true, using: :btree
  add_index "reportable_cache", ["model_name", "report_name", "grouping", "aggregation", "conditions"], name: "name_model_grouping_agregation", using: :btree

  create_table "roles", force: true do |t|
    t.string "title", default: "", null: false
  end

  add_index "roles", ["title"], name: "roles_title", using: :btree

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id", default: 0, null: false
    t.integer "user_id", default: 0, null: false
  end

  add_index "roles_users", ["role_id", "user_id"], name: "roles_users_role_fk", using: :btree
  add_index "roles_users", ["user_id"], name: "roles_users_user_fk", using: :btree

  create_table "settings", force: true do |t|
    t.integer  "user_id"
    t.boolean  "schafkopf",                   default: true,  null: false
    t.boolean  "skat",                        default: false, null: false
    t.boolean  "doppelkopf",                  default: false, null: false
    t.boolean  "watten",                      default: false, null: false
    t.boolean  "poker",                       default: false, null: false
    t.string   "other_games",                 default: "",    null: false
    t.boolean  "premium",                     default: false, null: false
    t.boolean  "real",                        default: false, null: false
    t.boolean  "online_play",                 default: true,  null: false
    t.boolean  "online_premium",              default: false, null: false
    t.boolean  "online_real_money",           default: false, null: false
    t.boolean  "online_play_tornament",       default: false, null: false
    t.boolean  "online_premium_tornament",    default: false, null: false
    t.boolean  "online_real_money_tornament", default: false, null: false
    t.boolean  "offline_party",               default: false, null: false
    t.boolean  "offline_tournament",          default: false, null: false
    t.boolean  "map_people",                  default: false, null: false
    t.boolean  "map_taverns",                 default: false, null: false
    t.boolean  "map_events",                  default: false, null: false
    t.boolean  "map_clubs",                   default: false, null: false
    t.boolean  "forum",                       default: false, null: false
    t.boolean  "shop",                        default: false, null: false
    t.boolean  "statistics",                  default: false, null: false
    t.boolean  "learn",                       default: false, null: false
    t.boolean  "friendship",                  default: false, null: false
    t.boolean  "dating",                      default: false, null: false
    t.boolean  "bavarian",                    default: false, null: false
    t.boolean  "notify_newsletter",           default: true,  null: false
    t.boolean  "notify_guestbook",            default: true,  null: false
    t.boolean  "notify_friendship",           default: true,  null: false
    t.boolean  "notify_private_message",      default: true,  null: false
    t.boolean  "notify_event",                default: true,  null: false
    t.boolean  "notify_new_feature",          default: true,  null: false
    t.boolean  "notify_coops",                default: true,  null: false
    t.boolean  "zamwerfen",                   default: true,  null: false
    t.boolean  "ramsch",                      default: false, null: false
    t.boolean  "klopfen_alle",                default: true,  null: false
    t.boolean  "klopfen_erster",              default: false, null: false
    t.boolean  "klopfen_pflichtspiel",        default: false, null: false
    t.boolean  "alter_pflichtspiel",          default: false, null: false
    t.boolean  "stock",                       default: false, null: false
    t.boolean  "doppeln_mehrmals",            default: false, null: false
    t.boolean  "doppeln_exp",                 default: false, null: false
    t.boolean  "rufspiel",                    default: true,  null: false
    t.boolean  "wenz",                        default: true,  null: false
    t.boolean  "solo",                        default: true,  null: false
    t.boolean  "farbwenz",                    default: false, null: false
    t.boolean  "geier",                       default: false, null: false
    t.boolean  "farbgeier",                   default: false, null: false
    t.boolean  "hochzeit",                    default: false, null: false
    t.boolean  "stossen_1",                   default: true,  null: false
    t.boolean  "stossen_selbst",              default: false, null: false
    t.boolean  "lang",                        default: true,  null: false
    t.boolean  "kurz",                        default: false, null: false
    t.string   "other_rules",                 default: "",    null: false
    t.datetime "interests_updated_at"
    t.datetime "rules_updated_at"
    t.datetime "notifications_updated_at"
    t.text     "game_preferences"
    t.integer  "monthly_deposit_limit"
    t.integer  "daily_deposit_count_limit"
  end

  add_index "settings", ["user_id"], name: "settings_user_fk", unique: true, using: :btree

  create_table "shop_order_items", force: true do |t|
    t.integer "shop_product_id",                         null: false
    t.integer "shop_order_id",                           null: false
    t.integer "quantity",                                null: false
    t.decimal "total_price",     precision: 8, scale: 2, null: false
    t.string  "size"
    t.string  "color"
  end

  add_index "shop_order_items", ["shop_order_id"], name: "order_items_orders_fk", using: :btree
  add_index "shop_order_items", ["shop_product_id"], name: "order_items_products_fk", using: :btree

  create_table "shop_orders", force: true do |t|
    t.integer  "user_id"
    t.text     "order_address"
    t.text     "shipping_address"
    t.string   "email"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_orders", ["user_id"], name: "orders_user_fk", using: :btree

  create_table "shop_products", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",           precision: 8, scale: 2, default: 0.0
    t.decimal  "vat",             precision: 4, scale: 2, default: 0.19
    t.string   "image"
    t.string   "sizes"
    t.string   "colors"
    t.integer  "coupon_months"
    t.string   "image_file_name"
    t.integer  "position",                                default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_stock",                                default: true, null: false
    t.boolean  "visible",                                 default: true, null: false
  end

  create_table "short_urls", force: true do |t|
    t.string   "code"
    t.string   "url"
    t.integer  "resolve_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "short_urls", ["code"], name: "index_short_urls_on_code", using: :btree

  create_table "shouts", force: true do |t|
    t.integer  "user_id",    default: 0,     null: false
    t.text     "comment",                    null: false
    t.datetime "created_at",                 null: false
    t.boolean  "deleted",    default: false, null: false
  end

  add_index "shouts", ["created_at"], name: "shouts_created_at", using: :btree
  add_index "shouts", ["user_id"], name: "shouts_user_fk", using: :btree

  create_table "test_bars", force: true do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_foos", force: true do |t|
    t.integer  "bar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_payouts", force: true do |t|
    t.string   "name"
    t.string   "payout_type"
    t.float    "payout_cut"
    t.string   "data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tournament_payouts_tournaments", id: false, force: true do |t|
    t.integer "tournament_id"
    t.integer "tournament_payout_id"
  end

  create_table "tournament_round_users", force: true do |t|
    t.integer  "user_id",                         null: false
    t.integer  "tournament_user_id",              null: false
    t.integer  "tournament_id",                   null: false
    t.integer  "round",                           null: false
    t.integer  "tournament_table_id",             null: false
    t.string   "state"
    t.integer  "points",              default: 0, null: false
    t.integer  "games_played",        default: 0, null: false
    t.integer  "offline_played",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sies_played",         default: 0
    t.integer  "touts_won",           default: 0
    t.integer  "touts_played",        default: 0
    t.integer  "solos_won",           default: 0
    t.integer  "solos_played",        default: 0
  end

  add_index "tournament_round_users", ["tournament_id", "round", "tournament_table_id"], name: "by_tournament_round_table_id", using: :btree

  create_table "tournament_templates", force: true do |t|
    t.string   "template_name"
    t.string   "name"
    t.text     "description"
    t.string   "kind"
    t.string   "state"
    t.datetime "scheduled_at"
    t.integer  "num_max_participants", default: 0
    t.string   "repeats_every"
    t.string   "special_rules"
    t.integer  "rate_id"
    t.integer  "balance_type"
    t.integer  "buy_in"
    t.integer  "rake"
    t.string   "payout_type"
    t.integer  "payout_cut"
    t.integer  "num_rounds"
    t.integer  "num_games_per_round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_users", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "tournament_id",              null: false
    t.string   "state"
    t.integer  "points"
    t.integer  "buy_in"
    t.integer  "rake"
    t.integer  "rank"
    t.text     "payout_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sies_played",    default: 0
    t.integer  "touts_won",      default: 0
    t.integer  "touts_played",   default: 0
    t.integer  "solos_won",      default: 0
    t.integer  "solos_played",   default: 0
    t.integer  "offline_played", default: 0, null: false
  end

  add_index "tournament_users", ["tournament_id", "user_id"], name: "tournament_users_user_unique", unique: true, using: :btree
  add_index "tournament_users", ["tournament_id"], name: "index_tournament_users_on_tournament_id", using: :btree
  add_index "tournament_users", ["user_id", "tournament_id"], name: "unique_registered_tournament_users", unique: true, where: "((state)::text = ANY ((ARRAY['registered'::character varying, 'playing'::character varying, 'finished'::character varying])::text[]))", using: :btree

  create_table "tournaments", force: true do |t|
    t.integer  "tournament_template_id"
    t.string   "name"
    t.text     "description"
    t.string   "kind"
    t.string   "state"
    t.datetime "scheduled_at"
    t.integer  "num_max_participants",   default: 0
    t.string   "repeats_every"
    t.string   "special_rules"
    t.integer  "rate_id"
    t.integer  "balance_type"
    t.integer  "buy_in"
    t.integer  "rake"
    t.integer  "num_rounds"
    t.integer  "num_games_per_round"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_payout_id"
    t.integer  "registered_users_count", default: 0
  end

  add_index "tournaments", ["state"], name: "index_tournaments_on_state", using: :btree

  create_table "trolls", force: true do |t|
    t.string   "user_id"
    t.string   "state"
    t.integer  "balance"
    t.integer  "balance_type"
    t.integer  "avg_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_computers", force: true do |t|
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "blocked_for_signup"
  end

  add_index "user_computers", ["key"], name: "index_user_computers_on_key", using: :btree

  create_table "user_notices", force: true do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_notices", ["user_id", "target_id"], name: "index_user_notices_on_user_id_and_target_id", using: :btree

  create_table "user_sessions", force: true do |t|
    t.integer  "user_computer_id"
    t.integer  "user_id"
    t.datetime "last_active"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["user_computer_id", "user_id", "ip_address"], name: "user_sessions_lookup_index", using: :btree
  add_index "user_sessions", ["user_computer_id"], name: "index_user_sessions_on_user_computer_id", using: :btree
  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",             limit: 40
    t.string   "salt",                         limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "verified"
    t.datetime "logged_in_at"
    t.boolean  "deleted"
    t.datetime "delete_after"
    t.string   "activation_code",              limit: 40
    t.datetime "activated_at"
    t.string   "password_reset_code",          limit: 40
    t.boolean  "serious",                                 default: false,     null: false
    t.boolean  "legal",                                   default: false,     null: false
    t.string   "firstname",                    limit: 30
    t.string   "lastname",                     limit: 30
    t.date     "birthday"
    t.string   "gender",                       limit: 10
    t.string   "salutation",                   limit: 10
    t.string   "street",                       limit: 40
    t.string   "zip_code",                     limit: 10
    t.string   "city",                         limit: 40
    t.string   "country",                      limit: 40
    t.integer  "balance_real",                            default: 0,         null: false
    t.integer  "on_server",                    limit: 2,  default: 0,         null: false
    t.string   "logged_in_from"
    t.string   "dependent_locality"
    t.string   "administrative_area"
    t.string   "country_code",                 limit: 2
    t.boolean  "real_money_allowed",                      default: false
    t.integer  "bonus_real",                              default: 0,         null: false
    t.integer  "bonus_games",                             default: 0,         null: false
    t.string   "id_card_id"
    t.datetime "last_active_at"
    t.string   "referer"
    t.string   "keywords"
    t.integer  "balance_real_in_play",                    default: 0
    t.string   "state",                                   default: "passive"
    t.datetime "deleted_at"
    t.boolean  "is_cheater",                              default: false
    t.boolean  "premium_subscription_allowed",            default: true
    t.string   "bcrypted_password"
  end

  add_index "users", ["email"], name: "users_email_index", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "users_remember_token_index", using: :btree

  create_table "versioned_asset_revisions", force: true do |t|
    t.integer  "versioned_asset_id"
    t.string   "revision"
    t.integer  "deploy_version"
    t.string   "rules"
    t.text     "rules_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versioned_asset_revisions", ["deploy_version"], name: "index_versioned_asset_revisions_on_deploy_version", using: :btree
  add_index "versioned_asset_revisions", ["versioned_asset_id"], name: "index_versioned_asset_revisions_on_versioned_asset_id", using: :btree

  create_table "versioned_assets", force: true do |t|
    t.string   "name"
    t.integer  "released_revision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versioned_assets", ["name"], name: "index_versioned_assets_on_name", using: :btree
  add_index "versioned_assets", ["released_revision_id"], name: "index_versioned_assets_on_released_revision_id", using: :btree

  create_table "votes", force: true do |t|
    t.datetime "created_at",                            null: false
    t.integer  "user_id",                  default: 0,  null: false
    t.string   "voteable_type", limit: 22, default: "", null: false
    t.integer  "voteable_id",              default: 0,  null: false
  end

  add_index "votes", ["user_id"], name: "votes_user_fk", using: :btree
  add_index "votes", ["voteable_id", "voteable_type", "user_id"], name: "votes_votable_user_unique", unique: true, using: :btree

  create_table "website_themes", force: true do |t|
    t.string   "name"
    t.string   "css_modifier_logo"
    t.boolean  "active",            default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "website_themes", ["active"], name: "index_website_themes_on_active", using: :btree

  create_table "weekly_rankings", force: true do |t|
    t.integer "user_id"
    t.integer "balance_type"
    t.date    "start_of_period"
    t.integer "games_played"
    t.integer "gain"
    t.integer "gain_per_game"
    t.integer "wenz_won"
    t.integer "solo_won"
    t.integer "tout_won"
    t.integer "high_score",          default: 0, null: false
    t.integer "games_as_player",     default: 0, null: false
    t.integer "games_as_partner",    default: 0, null: false
    t.integer "games_as_enemy",      default: 0, null: false
    t.integer "sauspiel_won",        default: 0, null: false
    t.integer "wenz_tout_won",       default: 0, null: false
    t.integer "solo_tout_won",       default: 0, null: false
    t.integer "sauspiel_announced",  default: 0, null: false
    t.integer "wenz_announced",      default: 0, null: false
    t.integer "solo_announced",      default: 0, null: false
    t.integer "wenz_tout_announced", default: 0, null: false
    t.integer "solo_tout_announced", default: 0, null: false
    t.integer "sie_announced",       default: 0, null: false
    t.integer "knockings",           default: 0, null: false
    t.integer "kontra",              default: 0, null: false
    t.integer "re",                  default: 0, null: false
    t.integer "current_score",       default: 0, null: false
    t.integer "farbwenz_announced",  default: 0, null: false
    t.integer "geier_announced",     default: 0, null: false
    t.integer "farbwenz_won",        default: 0, null: false
    t.integer "geier_won",           default: 0, null: false
    t.integer "short_played",        default: 0, null: false
    t.integer "dirty_played",        default: 0, null: false
  end

  add_index "weekly_rankings", ["start_of_period", "gain"], name: "index_weekly_rankings_on_start_of_period_and_gain", using: :btree
  add_index "weekly_rankings", ["start_of_period", "gain_per_game"], name: "index_weekly_rankings_on_start_of_period_and_gain_per_game", using: :btree
  add_index "weekly_rankings", ["start_of_period", "games_played"], name: "index_weekly_rankings_on_start_of_period_and_games_played", using: :btree
  add_index "weekly_rankings", ["start_of_period", "solo_won"], name: "index_weekly_rankings_on_start_of_period_and_solo_won", using: :btree
  add_index "weekly_rankings", ["start_of_period", "tout_won"], name: "index_weekly_rankings_on_start_of_period_and_tout_won", using: :btree
  add_index "weekly_rankings", ["start_of_period", "wenz_won"], name: "index_weekly_rankings_on_start_of_period_and_wenz_won", using: :btree
  add_index "weekly_rankings", ["user_id", "balance_type", "start_of_period"], name: "weekly_lookup_index", using: :btree
  add_index "weekly_rankings", ["user_id"], name: "index_weekly_rankings_on_user_id", using: :btree

  create_table "world_record_participants", force: true do |t|
    t.integer "user_id"
    t.text    "message"
    t.integer "votes_count", default: 0, null: false
  end

end
