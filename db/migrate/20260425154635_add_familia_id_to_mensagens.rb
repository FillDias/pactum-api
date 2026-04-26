class AddFamiliaIdToMensagens < ActiveRecord::Migration[7.2]
  def change
    add_column :mensagens, :familia_id, :uuid
    add_index :mensagens, :familia_id
  end
end
