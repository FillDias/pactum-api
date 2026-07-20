class CreateCartoes < ActiveRecord::Migration[7.2]
  def change
    create_table :cartoes, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid    :user_id, null: false
      t.uuid    :familia_id
      t.string  :apelido
      t.string  :operadora, null: false
      t.decimal :limite, precision: 10, scale: 2

      t.timestamps
    end

    add_index :cartoes, :user_id
    add_index :cartoes, :familia_id
  end
end
