class CartaoService
  def self.listar(user, escopo: nil)
    familia = user.familia
    ids = if escopo == "eu" || familia.nil?
      [user.id]
    else
      FamiliaService.membros_ids(familia)
    end

    Cartao.where(user_id: ids).order(created_at: :desc)
  end

  def self.criar(user, params)
    cartao = Cartao.new(
      user_id: user.id,
      familia_id: user.familia_id,
      apelido: params[:apelido],
      operadora: params[:operadora],
      limite: params[:limite]
    )

    return { error: cartao.errors.full_messages.first } unless cartao.save

    { cartao: cartao }
  end

  def self.atualizar(id, user_id, params)
    cartao = Cartao.find_by(id: id, user_id: user_id)
    return { error: "Cartao nao encontrado" } unless cartao

    return { error: cartao.errors.full_messages.first } unless cartao.update(params)

    { cartao: cartao }
  end

  def self.deletar(id, user_id)
    cartao = Cartao.find_by(id: id, user_id: user_id)
    return { error: "Cartao nao encontrado" } unless cartao

    cartao.destroy
    { success: true }
  end
end
