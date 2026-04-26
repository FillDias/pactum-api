class CasalService
  def self.criar(user)
    return { error: "Usuario ja possui um casal" } if user.casal

    casal = Casal.create(usuario1_id: user.id)
    return { error: casal.errors.full_messages.first } unless casal.persisted?

    { casal: casal }
  end

  def self.vincular(user, email_conjuge)
    casal = user.casal
    return { error: "Usuario nao possui um casal" } unless casal
    return { error: "Casal ja possui um conjuge" } if casal.usuario2_id.present?

    conjuge = User.find_by(email: email_conjuge)
    return { error: "Conjuge nao encontrado" } unless conjuge
    return { error: "Conjuge ja possui um casal" } if conjuge.casal

    return { error: casal.errors.full_messages.first } unless casal.update(usuario2_id: conjuge.id)

    { casal: casal }
  end
end
