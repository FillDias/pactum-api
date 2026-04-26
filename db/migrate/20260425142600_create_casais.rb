class CreateCasais < ActiveRecord::Migration[7.2]
  def change
    create_table :casais, id: :uuid do |t|
      t.string :nome, default: "Pactum"
      t.uuid :usuario1_id, null: false
      t.uuid :usuario2_id

      t.timestamps
    end
  end
end
