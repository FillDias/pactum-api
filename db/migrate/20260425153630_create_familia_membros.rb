class CreateFamiliaMembros < ActiveRecord::Migration[7.2]
  def change
    create_table :familia_membros, id: :uuid do |t|
      t.uuid :familia_id, null: false
      t.uuid :user_id, null: false
      t.string :papel, null: false, default: "membro"

      t.timestamps
    end

    add_index :familia_membros, [:familia_id, :user_id], unique: true
    add_index :familia_membros, :user_id
  end
end
