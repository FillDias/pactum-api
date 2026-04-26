class ReceitaService
  def self.listar(user, mes, ano)
    familia = user.familia

    if familia
      ids = FamiliaService.membros_ids(familia)
      Receita.where(user_id: ids, mes: mes, ano: ano)
             .order(created_at: :desc)
    else
      Receita.where(user_id: user.id, mes: mes, ano: ano)
             .order(created_at: :desc)
    end
  end

  def self.criar(user, params)
    receita = Receita.new(
      user_id: user.id,
      familia_id: user.familia_id,
      descricao: params[:descricao],
      valor: params[:valor],
      tipo: params[:tipo] || "salario",
      recorrente: params[:recorrente] || false,
      mes: params[:mes],
      ano: params[:ano]
    )

    return { error: receita.errors.full_messages.first } unless receita.save

    notificar(user, receita)
    { receita: receita }
  end

  def self.atualizar(id, user_id, params)
    receita = Receita.find_by(id: id, user_id: user_id)
    return { error: "Receita nao encontrada" } unless receita

    return { error: receita.errors.full_messages.first } unless receita.update(params)

    { receita: receita }
  end

  def self.deletar(id, user_id)
    receita = Receita.find_by(id: id, user_id: user_id)
    return { error: "Receita nao encontrada" } unless receita

    receita.destroy
    { success: true }
  end

  def self.total(user, mes, ano)
    listar(user, mes, ano).sum(:valor)
  end

  private

  def self.notificar(user, receita)
    familia = user.familia
    return unless familia

    Mensagem.create(
      user_id: user.id,
      familia_id: familia.id,
      conteudo: "#{user.nome} adicionou receita #{receita.descricao} de R$ #{receita.valor}",
      tipo: "sistema"
    )
  end
end
