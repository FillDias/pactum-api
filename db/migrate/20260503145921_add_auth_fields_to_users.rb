class AddAuthFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :email_verified_at, :datetime
    add_column :users, :email_verification_token, :string
    add_index :users, :reset_password_token, unique: true
    add_index :users, :email_verification_token, unique: true
  end
end
