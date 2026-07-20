class AddDiaVencimentoToCartoes < ActiveRecord::Migration[7.2]
  def change
    add_column :cartoes, :dia_vencimento, :integer
  end
end
