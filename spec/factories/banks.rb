FactoryBot.define do
  factory :bank do
    name { Faker::Bank.name }
    sequence(:code) { |n| n.to_s.rjust(3, '0') }
  end
end
