class InvestimentoService
  def self.listar(user_id)
    Investimento.where(user_id: user_id).order(created_at: :desc)
  end

  def self.criar(user_id, params)
    investimento = Investimento.new(
      user_id: user_id,
      nome: params[:nome],
      tipo: params[:tipo],
      valor_investido: params[:valor_investido],
      quantidade: params[:quantidade],
      rentabilidade_tipo: params[:rentabilidade_tipo],
      rentabilidade_percentual: params[:rentabilidade_percentual],
      data_inicio: params[:data_inicio],
      vencimento: params[:vencimento]
    )

    return { error: investimento.errors.full_messages.first } unless investimento.save

    { investimento: investimento }
  end

  def self.atualizar(id, user_id, params)
    investimento = Investimento.find_by(id: id, user_id: user_id)
    return { error: "Investimento nao encontrado" } unless investimento

    return { error: investimento.errors.full_messages.first } unless investimento.update(params)

    { investimento: investimento }
  end

  def self.deletar(id, user_id)
    investimento = Investimento.find_by(id: id, user_id: user_id)
    return { error: "Investimento nao encontrado" } unless investimento

    investimento.destroy
    { success: true }
  end

  def self.patrimonio_total(user_id)
    listar(user_id).sum(:valor_investido)
  end

  def self.rendimento_mensal_total(user_id)
    listar(user_id).sum do |inv|
      inv.rendimento_mensal_estimado
    end
  end
end
