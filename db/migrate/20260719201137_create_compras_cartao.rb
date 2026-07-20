class CreateComprasCartao < ActiveRecord::Migration[7.2]
  def change
    create_table :compras_cartao, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid     :user_id, null: false
      t.uuid     :familia_id
      t.uuid     :cartao_id, null: false
      t.string   :descricao, null: false
      t.decimal  :valor_total, precision: 10, scale: 2, null: false
      t.integer  :numero_parcelas, null: false
      t.integer  :mes_referencia, null: false
      t.integer  :ano_referencia, null: false
      t.datetime :cancelada_em

      t.timestamps
    end

    add_index :compras_cartao, :cartao_id
    add_index :compras_cartao, :user_id
  end
end
