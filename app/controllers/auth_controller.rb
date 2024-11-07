# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  # Register endpoint (no change here, assuming you already have it)
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login endpoint (with access and refresh tokens)
  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      # Encode access and refresh tokens
      access_token = JsonWebToken.encode(user_id: user.id)
      refresh_token = JsonWebToken.encode_refresh_token(user_id: user.id)

      render json: { 
        access_token: access_token, 
        refresh_token: refresh_token, 
        message: "Logged in successfully" 
      }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  # Refresh token endpoint (new endpoint to handle refresh token)
  def refresh
    refresh_token = params[:refresh_token]

    # Decode the refresh token
    decoded_token = JsonWebToken.decode(refresh_token, :refresh)

    if decoded_token
      user = User.find(decoded_token[:user_id])

      # Generate a new access token and refresh token
      new_access_token = JsonWebToken.encode(user_id: user.id)
      new_refresh_token = JsonWebToken.encode_refresh_token(user_id: user.id)

      render json: { 
        access_token: new_access_token, 
        refresh_token: new_refresh_token, 
        message: "Tokens refreshed successfully" 
      }, status: :ok
    else
      render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:auth).permit(:username, :email, :full_name, :password, :role)
  end
end
