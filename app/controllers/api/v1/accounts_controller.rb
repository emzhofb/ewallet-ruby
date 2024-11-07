class Api::V1::AccountsController < ApplicationController
  before_action :authorize_request # This would be a method to authorize JWT token and set @current_user

  # GET /api/v1/accounts
  def index
    # Fetch accounts for the current logged-in user
    @accounts = @current_user.accounts
    render json: @accounts, status: :ok
  end

  # POST /api/v1/accounts
  def create
    # Check if current_user is nil
    if @current_user.nil?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    # Create the new account and assign the current_user as the owner
    @account = Account.new(account_params)
    @account.owner = @current_user  # Explicitly setting current_user as the account's owner

    if @account.save
      render json: { message: 'Account created successfully', account: @account }, status: :created
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/accounts/:id
  def show
    @account = @current_user.accounts.find_by(id: params[:id])

    if @account
      render json: @account, status: :ok
    else
      render json: { error: 'Account not found' }, status: :not_found
    end
  end

  private

  def account_params
    params.require(:account).permit(:currency, :balance)
  end
end
