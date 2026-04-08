class Category < ApplicationRecord
  enum :category_type, { expense: 0, income: 1 }

  belongs_to :account

  monetize :budget_cents

  validates :name, presence: true, uniqueness: true
  validates :category_type, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: 0 }
  validates :icon, presence: true
end
