# app/models/user.rb
class User < ApplicationRecord
  validates :role, inclusion: { in: %w(user stock team), message: "%{value} is not a valid role" }

  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true

  # Helper methods for roles
  def user?
    role == 'user'
  end

  def stock?
    role == 'stock'
  end

  def team?
    role == 'team'
  end
end
