FactoryBot.define do
  factory :enterprise do
    legal_name { "#{Faker::Company.name} LTDA" }
    trade_name { Faker::Company.name }
    sequence(:cnpj) { |n| format('%<n>02d.%<n>03d.%<n>03d/0001-%<mod>02d', n:, mod: n % 100) }
    owner factory: %i[user]
  end
end
