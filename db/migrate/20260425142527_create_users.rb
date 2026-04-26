class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.uuid :casal_id

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
