class AuthService
  def self.registrar(params)
    user = User.new(
      nome: params[:nome],
      email: params[:email],
      password: params[:password]
    )

    return { error: user.errors.full_messages.first } unless user.save

    token = JwtService.encode(user_id: user.id)
    { user: user, token: token }
  end

  def self.login(email, password)
    user = User.find_by(email: email)

    return { error: "Email ou senha incorretos" } unless user&.authenticate(password)

    token = JwtService.encode(user_id: user.id)
    { user: user, token: token }
  end
end
