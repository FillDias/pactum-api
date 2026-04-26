class AddFamiliaIdToLancamentos < ActiveRecord::Migration[7.2]
  def change
    add_column :lancamentos, :familia_id, :uuid
    add_index :lancamentos, :familia_id
  end
end
