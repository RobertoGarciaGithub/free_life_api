class Account < ApplicationRecord
  monetize :amount_cents

  belongs_to :accountable, polymorphic: true
  belongs_to :bank

  has_many :transactions, as: :transactable, dependent: :destroy

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :profitability, presence: true, numericality: { only_integer: true }
end
