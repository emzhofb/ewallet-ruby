# app/lib/json_web_token.rb
class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base # Secret key from Rails config
  REFRESH_SECRET_KEY = Rails.application.secret_key_base + "_refresh" # Secret key for refresh tokens

  # Encode the access token JWT
  def self.encode(payload, exp = 24.hours.from_now.to_i)
    payload[:exp] = exp
    JWT.encode(payload, SECRET_KEY)
  end

  # Encode the refresh token JWT
  def self.encode_refresh_token(payload, exp = 30.days.from_now.to_i)
    payload[:exp] = exp
    JWT.encode(payload, REFRESH_SECRET_KEY)
  end

  # Decode the access token JWT
  def self.decode(token, type = :access)
    secret_key = type == :access ? SECRET_KEY : REFRESH_SECRET_KEY
    body = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new(body) # Return payload as a hash
  rescue JWT::DecodeError => e
    nil
  end
end
