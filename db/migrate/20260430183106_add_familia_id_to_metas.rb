class AddFamiliaIdToMetas < ActiveRecord::Migration[7.2]
  def change
    add_column :metas, :familia_id, :integer
    add_column :metas, :user_id, :integer
    add_index :metas, :familia_id
    add_index :metas, :user_id
    change_column_null :metas, :casal_id, true
  end
end
