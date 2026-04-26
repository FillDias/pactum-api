class CreateMetas < ActiveRecord::Migration[7.2]
  def change
    create_table :metas, id: :uuid do |t|
      t.uuid :casal_id, null: false
      t.string :titulo, null: false
      t.decimal :valor_alvo, precision: 10, scale: 2
      t.decimal :valor_atual, precision: 10, scale: 2, default: 0
      t.date :prazo

      t.timestamps
    end

    add_index :metas, :casal_id
  end
end
