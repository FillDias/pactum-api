class AddCartaoFieldsToLancamentos < ActiveRecord::Migration[7.2]
  def change
    add_column :lancamentos, :compra_cartao_id, :uuid
    add_column :lancamentos, :numero_parcela, :integer

    add_index :lancamentos, :compra_cartao_id
    add_index :lancamentos, [:compra_cartao_id, :numero_parcela],
      unique: true,
      where: "compra_cartao_id IS NOT NULL",
      name: "index_lancamentos_on_compra_cartao_id_and_numero_parcela"
  end
end
