class Entry < ApplicationRecord
  belongs_to :account, class_name: 'Account'

  validates :amount, presence: true
end
