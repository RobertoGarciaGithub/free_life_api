# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    sequence(:email) { |n| "#{Faker::Internet.username(specifier: first_name).downcase}#{n}@#{Faker::Internet.domain_name}" }
    sequence(:document) { |n| Faker::Number.number(digits: 10).to_s + n.to_s }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
