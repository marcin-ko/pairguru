FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { Faker::Lorem.word }
    password { "password" }
    confirmed_at { Faker::Date.between(40.years.ago, Time.zone.today) }
  end
end
