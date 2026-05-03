class LancamentoService
  def self.listar(user, mes, ano, categoria: nil)
    familia = user.familia
    ids = familia ? FamiliaService.membros_ids(familia) : [user.id]

    scope = Lancamento.where(user_id: ids, mes: mes, ano: ano)
    scope = scope.where(categoria: categoria) if categoria.present?
    scope.order(created_at: :desc)
  end

  def self.criar(user, params)
    lancamento = Lancamento.new(
      user_id: user.id,
      familia_id: user.familia_id,
      descricao: params[:descricao],
      valor: params[:valor],
      tipo: params[:tipo],
      categoria: params[:categoria],
      vencimento: params[:vencimento],
      mes: params[:mes],
      ano: params[:ano],
      recorrente: params[:recorrente] || false
    )

    return { error: lancamento.errors.full_messages.first } unless lancamento.save

    notificar(user, lancamento)
    { lancamento: lancamento }
  end

  def self.atualizar(id, user_id, params)
    lancamento = Lancamento.find_by(id: id, user_id: user_id)
    return { error: "Lancamento nao encontrado" } unless lancamento

    return { error: lancamento.errors.full_messages.first } unless lancamento.update(params)

    { lancamento: lancamento }
  end

  def self.deletar(id, user_id)
    lancamento = Lancamento.find_by(id: id, user_id: user_id)
    return { error: "Lancamento nao encontrado" } unless lancamento

    lancamento.destroy
    { success: true }
  end

  private

  def self.notificar(user, lancamento)
    familia = user.familia
    return unless familia

    emoji = lancamento.tipo == "despesa" ? "gastou" : "recebeu"

    Mensagem.create(
      user_id: user.id,
      familia_id: familia.id,
      conteudo: "#{user.nome} #{emoji} R$ #{lancamento.valor} em #{lancamento.descricao}",
      tipo: "sistema"
    )
  end
end
