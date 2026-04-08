class Enterprise < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :accounts, as: :accountable, dependent: :restrict_with_error

  validates :legal_name, presence: true
  validates :cnpj, presence: true, uniqueness: true
end
