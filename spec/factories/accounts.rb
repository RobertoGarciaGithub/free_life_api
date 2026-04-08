FactoryBot.define do
  factory :account do
    accountable factory: %i[user]
    bank

    amount_cents { Faker::Number.between(from: 1_000_00, to: 100_000_00) }
    profitability { Faker::Number.between(from: 0, to: 100) }
  end
end
