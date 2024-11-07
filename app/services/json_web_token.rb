# app/services/json_web_token.rb
class JsonWebToken
  # Secret key to encode and decode the token
  SECRET_KEY = Rails.application.secret_key_base.to_s

  # Method to encode a JWT token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i  # expiration time
    JWT.encode(payload, SECRET_KEY)
  end

  # Method to decode a JWT token
  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError
    nil
  end
end
