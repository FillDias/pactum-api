class RemoveCasalIdNotNullFromLancamentosAndMensagens < ActiveRecord::Migration[7.2]
  def change
    change_column_null :lancamentos, :casal_id, true
    change_column_null :mensagens, :casal_id, true
  end
end
