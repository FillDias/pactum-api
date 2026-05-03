class JwtService
  ALGORITHM        = "HS256"
  ACCESS_TTL       = 1.hour
  REFRESH_TTL      = 30.days

  def self.encode(payload)
    payload = payload.merge(exp: ACCESS_TTL.from_now.to_i, type: "access")
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.encode_refresh(payload)
    payload = payload.merge(exp: REFRESH_TTL.from_now.to_i, type: "refresh")
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.decode(token)
    data = JWT.decode(token, secret, true, algorithm: ALGORITHM).first
    return nil unless data["type"] == "access"
    data
  rescue JWT::DecodeError
    nil
  end

  def self.decode_refresh(token)
    data = JWT.decode(token, secret, true, algorithm: ALGORITHM).first
    return nil unless data["type"] == "refresh"
    data
  rescue JWT::DecodeError
    nil
  end

  def self.secret
    ENV.fetch("JWT_SECRET")
  end
end
