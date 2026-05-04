class FamiliaService
  CODIGO_CHARS = ("A".."Z").to_a + ("0".."9").to_a

  def self.criar(user, nome = "Minha Familia")
    return { error: "Usuario ja possui uma familia" } if user.familia

    familia = Familia.new(nome: nome, criado_por: user.id, codigo_convite: gerar_codigo_unico)

    ActiveRecord::Base.transaction do
      familia.save!
      FamiliaMembro.create!(
        familia_id: familia.id,
        user_id: user.id,
        papel: "dono"
      )
    end

    { familia: familia }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

  def self.convidar(user, email_convidado)
    familia = user.familia
    return { error: "Voce nao possui uma familia" } unless familia
    return { error: "Apenas o dono pode convidar membros" } unless dono?(familia, user)

    convidado = User.find_by(email: email_convidado)
    return { error: "Usuario nao encontrado" } unless convidado
    return { error: "Usuario ja e membro de uma familia" } if convidado.familia

    membro = FamiliaMembro.create(
      familia_id: familia.id,
      user_id: convidado.id,
      papel: "membro"
    )

    return { error: membro.errors.full_messages.first } unless membro.persisted?

    { familia: familia, membro: convidado }
  end

  def self.entrar_por_codigo(user, codigo)
    return { error: "Usuario ja possui uma familia" } if user.familia

    familia = Familia.find_by(codigo_convite: codigo.to_s.strip.upcase)
    return { error: "Codigo invalido" } unless familia

    membro = FamiliaMembro.create(
      familia_id: familia.id,
      user_id: user.id,
      papel: "membro"
    )

    return { error: membro.errors.full_messages.first } unless membro.persisted?

    { familia: familia }
  end

  def self.membros_ids(familia)
    FamiliaMembro.where(familia_id: familia.id).pluck(:user_id)
  end

  def self.dono?(familia, user)
    FamiliaMembro.exists?(
      familia_id: familia.id,
      user_id: user.id,
      papel: "dono"
    )
  end

  def self.papel_do_membro(familia, user)
    FamiliaMembro.find_by(familia_id: familia.id, user_id: user.id)&.papel
  end

  private

  def self.gerar_codigo_unico
    loop do
      codigo = Array.new(6) { CODIGO_CHARS.sample }.join
      return codigo unless Familia.exists?(codigo_convite: codigo)
    end
  end
end
