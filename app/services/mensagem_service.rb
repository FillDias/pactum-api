class MensagemService
  def self.listar(casal_id)
    Mensagem.where(casal_id: casal_id).limit(100)
  end

  def self.criar(casal_id, user_id, conteudo)
    mensagem = Mensagem.create(
      casal_id: casal_id,
      user_id: user_id,
      conteudo: conteudo,
      tipo: "texto"
    )

    return { error: mensagem.errors.full_messages.first } unless mensagem.persisted?

    { mensagem: mensagem }
  end

  def self.criar_sistema(casal_id, user_id, conteudo)
    Mensagem.create(
      casal_id: casal_id,
      user_id: user_id,
      conteudo: conteudo,
      tipo: "sistema"
    )
  end
end
