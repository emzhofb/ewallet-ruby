class Account < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  # Optional: Validation for balance
  validates :currency, presence: true
  validates :owner_id, presence: true  # Ensure the owner_id is validated
  validates :balance, numericality: { greater_than_or_equal_to: 0.0 }
  validates :currency, uniqueness: { scope: :owner_id, message: "User already has an account with this currency" }
end
