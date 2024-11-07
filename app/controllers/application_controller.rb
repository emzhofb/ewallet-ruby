class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Skip CSRF token verification for API requests
  protect_from_forgery with: :null_session
  # Handle Routing Errors with custom response
  rescue_from ActionController::RoutingError, with: :route_not_found

  # Handle ActiveRecord errors for missing records
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Handle other general errors
  rescue_from StandardError, with: :internal_server_error

  private

  # Handle 404 for route not found
  def route_not_found
    render json: { error: 'Route not found' }, status: :not_found
  end

  # Handle 404 for record not found
  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  # Handle internal server errors
  def internal_server_error
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
  
  # This will allow us to authenticate the user from the token
  def authorize_request
    # Get the token from the Authorization header
    token = request.headers['Authorization']
    
    # Check if token is provided and if it is properly formatted
    if token.nil? || !token.starts_with?('Bearer ')
      render json: { error: 'Missing or invalid token' }, status: :unauthorized
      return
    end

    begin
      # Remove 'Bearer ' from the token string
      token = token.split(' ').last

      # Decode the token using JsonWebToken
      @decoded = JsonWebToken.decode(token)

      if @decoded.nil?
        render json: { error: 'Invalid token' }, status: :unauthorized
        return
      end

      # Find the user based on the decoded token
      @current_user = User.find(@decoded[:user_id])

    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
