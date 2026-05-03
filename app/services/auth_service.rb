class AuthService
  def self.registrar(params)
    user = User.new(
      nome:     params[:nome],
      email:    params[:email],
      password: params[:password]
    )

    return { error: user.errors.full_messages.first } unless user.save

    send_verification(user)
    tokens_for(user).merge(user: user)
  end

  def self.login(email, password)
    user = User.find_by(email: email&.downcase&.strip)
    return { error: "Email ou senha incorretos" } unless user&.authenticate(password)

    tokens_for(user).merge(user: user)
  end

  def self.refresh(refresh_token)
    payload = JwtService.decode_refresh(refresh_token)
    return { error: "Token invalido ou expirado" } unless payload

    user = User.find_by(id: payload["user_id"])
    return { error: "Usuario nao encontrado" } unless user

    tokens_for(user).merge(user: user)
  end

  def self.forgot_password(email)
    user = User.find_by(email: email&.downcase&.strip)
    return { ok: true } unless user  # não revela se email existe

    user.generate_reset_token!
    UserMailer.reset_password_email(user).deliver_later
    { ok: true }
  end

  def self.reset_password(token, new_password)
    user = User.find_by(reset_password_token: token)
    return { error: "Token invalido ou expirado" } unless user&.reset_token_valid?
    return { error: "Senha muito curta (minimo 6 caracteres)" } if new_password.to_s.length < 6

    user.reset_password!(new_password)
    tokens_for(user).merge(user: user)
  end

  def self.send_verification(user)
    user.generate_verification_token!
    UserMailer.verification_email(user).deliver_later
  end

  def self.verify_email(token)
    user = User.find_by(email_verification_token: token)
    return { error: "Token invalido" } unless user

    user.verify_email!
    tokens_for(user).merge(user: user)
  end

  private

  def self.tokens_for(user)
    {
      token:         JwtService.encode(user_id: user.id),
      refresh_token: JwtService.encode_refresh(user_id: user.id),
    }
  end
end
