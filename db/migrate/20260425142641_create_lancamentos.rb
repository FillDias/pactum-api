class CreateLancamentos < ActiveRecord::Migration[7.2]
  def change
    create_table :lancamentos, id: :uuid do |t|
      t.uuid :casal_id, null: false
      t.uuid :user_id, null: false
      t.string :descricao, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.string :tipo, null: false
      t.string :categoria
      t.integer :vencimento
      t.integer :mes, null: false
      t.integer :ano, null: false
      t.boolean :recorrente, default: false

      t.timestamps
    end

    add_index :lancamentos, :casal_id
    add_index :lancamentos, :user_id
    add_index :lancamentos, [:casal_id, :mes, :ano]
  end
end
