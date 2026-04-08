class Transaction < ApplicationRecord
  monetize :amount_cents
  belongs_to :transactable, polymorphic: true
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :user

  enum :transactions_type, { debit: 0, credit: 1, transfer: 2 }
  enum :status, { pending: 0, completed: 1, cancelled: 2 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :transactions_type, presence: true
  validates :status, presence: true
end
