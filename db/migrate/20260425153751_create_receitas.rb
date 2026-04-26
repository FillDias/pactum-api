class CreateReceitas < ActiveRecord::Migration[7.2]
  def change
    create_table :receitas, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :familia_id
      t.string :descricao, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.string :tipo, null: false, default: "salario"
      t.boolean :recorrente, default: true
      t.integer :mes, null: false
      t.integer :ano, null: false

      t.timestamps
    end

    add_index :receitas, :user_id
    add_index :receitas, [:user_id, :mes, :ano]
  end
end
