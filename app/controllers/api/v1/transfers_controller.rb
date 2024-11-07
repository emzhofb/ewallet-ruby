class Api::V1::TransfersController < ApplicationController
  before_action :authorize_request  # This would be a method to authorize JWT token and set @current_user

  # POST /api/v1/transfers
  def create
    # Find both accounts
    from_account = @current_user.accounts.first
    logger.debug "From account retrieved: #{from_account.inspect} with params: #{params[:from_account_id]}"
    
    to_account = Account.find_by(id: params[:to_account_id])
    logger.debug "To account retrieved: #{to_account.inspect} with params: #{params[:to_account_id]}"

    # Check if both accounts exist
    if from_account.nil? || to_account.nil?
      render json: { error: 'Invalid accounts' }, status: :unprocessable_entity
      return
    end

    # Check if the transfer amount is valid
    amount = params[:amount].to_f
    if amount <= 0 || from_account.balance < amount
      render json: { error: 'Invalid transfer amount or insufficient funds' }, status: :unprocessable_entity
      return
    end

    # Validate that the accounts have the same currency
    if from_account.currency != to_account.currency
      render json: { error: 'Currency mismatch between accounts' }, status: :unprocessable_entity
      return
    end

    # Start a transaction to ensure both tables are updated
    # This use db transaction lock, to ensure that all communication to db must be success otherwise no table will updated if one of them failed.
    ActiveRecord::Base.transaction do
      # Create the transfer record
      @transfer = Transfer.create!(
        from_account: from_account,
        to_account: to_account,
        amount: amount
      )

      # Create the entry for the 'from' account (subtract balance)
      Entry.create!(
        account: from_account,
        amount: -amount  # Negative for deduction
      )

      # Create the entry for the 'to' account (add balance)
      Entry.create!(
        account: to_account,
        amount: amount  # Positive for addition
      )

      # Update account balances
      from_account.update!(balance: from_account.balance - amount)
      to_account.update!(balance: to_account.balance + amount)
    end

    render json: { message: 'Transfer successful', transfer: @transfer }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
