class AddCodigoConviteToFamilias < ActiveRecord::Migration[7.2]
  def change
    add_column :familias, :codigo_convite, :string
    add_index :familias, :codigo_convite, unique: true
  end
end
