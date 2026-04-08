FactoryBot.define do
  factory :transaction do
    transactable factory: %i[account]
    user

    amount_cents  { Faker::Number.between(from: 1_00, to: 10_000_00) }
    description   { Faker::Lorem.sentence }
    transactions_type { :debit }
    status            { :pending }

    trait :credit do
      transactions_type { :credit }
    end

    trait :transfer do
      transactions_type { :transfer }
    end

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :with_target do
      target factory: %i[account]
    end
  end
end
