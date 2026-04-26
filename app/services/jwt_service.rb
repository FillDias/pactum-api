class JwtService
  ALGORITHM = "HS256"
  EXPIRATION = 24 * 60 * 60

  def self.encode(payload)
    payload[:exp] = Time.now.to_i + EXPIRATION
    JWT.encode(payload, ENV.fetch("JWT_SECRET"), ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, ENV.fetch("JWT_SECRET"), true, algorithm: ALGORITHM).first
  rescue JWT::DecodeError
    nil
  end
end
