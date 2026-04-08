FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    category_type { %i[income expense].sample }
    budget { Faker::Commerce.price(range: 1..1000) }
    icon { "fa-solid fa-#{Faker::Commerce.material}" }
    account factory: %i[account]
  end
end
