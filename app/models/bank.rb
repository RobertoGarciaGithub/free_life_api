class Bank < ApplicationRecord
  has_many :accounts, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end
