class User < ApplicationRecord
  has_many :accounts, as: :accountable, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :document, presence: true, uniqueness: true
end
