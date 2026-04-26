class MetaService
  def self.listar(casal_id)
    Meta.where(casal_id: casal_id).order(created_at: :desc)
  end

  def self.criar(casal_id, params)
    meta = Meta.create(
      casal_id: casal_id,
      titulo: params[:titulo],
      valor_alvo: params[:valor_alvo],
      valor_atual: params[:valor_atual] || 0,
      prazo: params[:prazo]
    )

    return { error: meta.errors.full_messages.first } unless meta.persisted?

    { meta: meta }
  end

  def self.atualizar(id, casal_id, params)
    meta = Meta.find_by(id: id, casal_id: casal_id)
    return { error: "Meta nao encontrada" } unless meta

    return { error: meta.errors.full_messages.first } unless meta.update(params)

    { meta: meta }
  end

  def self.deletar(id, casal_id)
    meta = Meta.find_by(id: id, casal_id: casal_id)
    return { error: "Meta nao encontrada" } unless meta

    meta.destroy
    { success: true }
  end
end
