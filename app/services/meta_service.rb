class MetaService
  def self.listar(user)
    familia = user.familia
    if familia
      Meta.where(familia_id: familia.id).order(created_at: :desc)
    else
      Meta.where(user_id: user.id).order(created_at: :desc)
    end
  end

  def self.criar(user, params)
    familia = user.familia
    meta = Meta.create(
      familia_id: familia&.id,
      user_id: user.id,
      titulo: params[:titulo],
      valor_alvo: params[:valor_alvo],
      valor_atual: params[:valor_atual] || 0,
      prazo: params[:prazo]
    )

    return { error: meta.errors.full_messages.first } unless meta.persisted?

    { meta: meta }
  end

  def self.atualizar(id, user, params)
    familia = user.familia
    meta = familia ? Meta.find_by(id: id, familia_id: familia.id) : Meta.find_by(id: id, user_id: user.id)
    return { error: "Meta nao encontrada" } unless meta

    return { error: meta.errors.full_messages.first } unless meta.update(params)

    { meta: meta }
  end

  def self.deletar(id, user)
    familia = user.familia
    meta = familia ? Meta.find_by(id: id, familia_id: familia.id) : Meta.find_by(id: id, user_id: user.id)
    return { error: "Meta nao encontrada" } unless meta

    meta.destroy
    { success: true }
  end
end
