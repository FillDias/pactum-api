class CreateMensagens < ActiveRecord::Migration[7.2]
  def change
    create_table :mensagens, id: :uuid do |t|
      t.uuid :casal_id, null: false
      t.uuid :user_id, null: false
      t.text :conteudo, null: false
      t.string :tipo, default: "texto"

      t.timestamps
    end

    add_index :mensagens, :casal_id
  end
end
