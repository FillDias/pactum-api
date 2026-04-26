class CreateInvestimentos < ActiveRecord::Migration[7.2]
  def change
    create_table :investimentos, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :nome, null: false
      t.string :tipo, null: false
      t.decimal :valor_investido, precision: 10, scale: 2, null: false
      t.decimal :quantidade, precision: 10, scale: 4
      t.string :rentabilidade_tipo
      t.decimal :rentabilidade_percentual, precision: 5, scale: 2
      t.date :data_inicio
      t.date :vencimento

      t.timestamps
    end

    add_index :investimentos, :user_id
  end
end
