# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
         :registerable,
         :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :accounts, as: :accountable, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :document,   presence: true, uniqueness: true
  # :email and :password validations are handled by devise's :validatable module
end
