class CompraCartaoService
  def self.criar(user, params)
    compra = CompraCartao.new(
      user_id: user.id,
      familia_id: user.familia_id,
      cartao_id: params[:cartao_id],
      descricao: params[:descricao],
      valor_total: params[:valor_total],
      numero_parcelas: params[:numero_parcelas],
      mes_referencia: params[:mes_referencia],
      ano_referencia: params[:ano_referencia]
    )

    return { error: compra.errors.full_messages.first } unless compra.save

    materializar_parcela!(compra, 1, compra.mes_referencia, compra.ano_referencia)

    { compra_cartao: compra }
  end

  def self.atualizar(id, user_id, params)
    compra = CompraCartao.find_by(id: id, user_id: user_id)
    return { error: "CompraCartao nao encontrada" } unless compra

    editaveis = params.slice(:descricao, :valor_total, :numero_parcelas)
    return { error: compra.errors.full_messages.first } unless compra.update(editaveis)

    { compra_cartao: compra }
  end

  def self.cancelar(id, user_id)
    compra = CompraCartao.find_by(id: id, user_id: user_id)
    return { error: "CompraCartao nao encontrada" } unless compra

    compra.update!(cancelada_em: Time.current)
    { compra_cartao: compra }
  end

  # Garante que a parcela do mes/ano pedido existe como Lancamento, para cada
  # CompraCartao ativa desses usuarios cujo intervalo cobre esse mes. Idempotente.
  def self.materializar_parcelas_do_mes!(user_ids, mes, ano)
    CompraCartao.where(user_id: user_ids, cancelada_em: nil).find_each do |compra|
      numero = compra.numero_da_parcela(mes, ano)
      next unless numero.between?(1, compra.numero_parcelas)

      materializar_parcela!(compra, numero, mes, ano)
    end
  end

  def self.comprometido_futuro(user, mes_atual, ano_atual, escopo: nil)
    familia = user.familia
    ids = if escopo == "eu" || familia.nil?
      [user.id]
    else
      FamiliaService.membros_ids(familia)
    end

    total = CompraCartao.where(user_id: ids, cancelada_em: nil).sum do |compra|
      numero_atual = compra.numero_da_parcela(mes_atual, ano_atual)
      primeira_futura = [numero_atual + 1, 1].max

      (primeira_futura..compra.numero_parcelas).sum { |n| compra.valor_parcela(n) }
    end

    total.round(2).to_f
  end

  def self.materializar_parcela!(compra, numero, mes, ano)
    Lancamento.find_or_create_by!(compra_cartao_id: compra.id, numero_parcela: numero) do |l|
      l.user_id = compra.user_id
      l.familia_id = compra.familia_id
      l.descricao = "#{compra.descricao} (#{numero}/#{compra.numero_parcelas})"
      l.valor = compra.valor_parcela(numero)
      l.tipo = "despesa"
      l.categoria = "Cartao"
      l.mes = mes
      l.ano = ano
      l.recorrente = false
    end
  rescue ActiveRecord::RecordNotUnique
    nil
  end
  private_class_method :materializar_parcela!
end
