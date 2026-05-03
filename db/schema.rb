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

ActiveRecord::Schema[7.2].define(version: 2026_05_03_145921) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "casais", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "nome", default: "Pactum"
    t.uuid "usuario1_id", null: false
    t.uuid "usuario2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "familia_membros", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "familia_id", null: false
    t.uuid "user_id", null: false
    t.string "papel", default: "membro", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["familia_id", "user_id"], name: "index_familia_membros_on_familia_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_familia_membros_on_user_id"
  end

  create_table "familias", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "nome", default: "Minha Familia", null: false
    t.uuid "criado_por", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investimentos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "nome", null: false
    t.string "tipo", null: false
    t.decimal "valor_investido", precision: 10, scale: 2, null: false
    t.decimal "quantidade", precision: 10, scale: 4
    t.string "rentabilidade_tipo"
    t.decimal "rentabilidade_percentual", precision: 5, scale: 2
    t.date "data_inicio"
    t.date "vencimento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_investimentos_on_user_id"
  end

  create_table "lancamentos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "casal_id"
    t.uuid "user_id", null: false
    t.string "descricao", null: false
    t.decimal "valor", precision: 10, scale: 2, null: false
    t.string "tipo", null: false
    t.string "categoria"
    t.integer "vencimento"
    t.integer "mes", null: false
    t.integer "ano", null: false
    t.boolean "recorrente", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "familia_id"
    t.index ["casal_id", "mes", "ano"], name: "index_lancamentos_on_casal_id_and_mes_and_ano"
    t.index ["casal_id"], name: "index_lancamentos_on_casal_id"
    t.index ["familia_id"], name: "index_lancamentos_on_familia_id"
    t.index ["user_id"], name: "index_lancamentos_on_user_id"
  end

  create_table "mensagens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "casal_id"
    t.uuid "user_id", null: false
    t.text "conteudo", null: false
    t.string "tipo", default: "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "familia_id"
    t.index ["casal_id"], name: "index_mensagens_on_casal_id"
    t.index ["familia_id"], name: "index_mensagens_on_familia_id"
  end

  create_table "metas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "casal_id"
    t.string "titulo", null: false
    t.decimal "valor_alvo", precision: 10, scale: 2
    t.decimal "valor_atual", precision: 10, scale: 2, default: "0.0"
    t.date "prazo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "familia_id"
    t.integer "user_id"
    t.index ["casal_id"], name: "index_metas_on_casal_id"
    t.index ["familia_id"], name: "index_metas_on_familia_id"
    t.index ["user_id"], name: "index_metas_on_user_id"
  end

  create_table "receitas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "familia_id"
    t.string "descricao", null: false
    t.decimal "valor", precision: 10, scale: 2, null: false
    t.string "tipo", default: "salario", null: false
    t.boolean "recorrente", default: true
    t.integer "mes", null: false
    t.integer "ano", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "mes", "ano"], name: "index_receitas_on_user_id_and_mes_and_ano"
    t.index ["user_id"], name: "index_receitas_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "nome", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.uuid "casal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "email_verified_at"
    t.string "email_verification_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["email_verification_token"], name: "index_users_on_email_verification_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
