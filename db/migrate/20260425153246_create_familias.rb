class CreateFamilias < ActiveRecord::Migration[7.2]
  def change
    create_table :familias, id: :uuid do |t|
      t.string :nome, null: false, default: "Minha Familia"
      t.uuid :criado_por, null: false

      t.timestamps
    end
  end
end
