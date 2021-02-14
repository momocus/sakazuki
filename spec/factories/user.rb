FactoryBot.define do
  factory :user do
    admin { true }
    password { "password" }
    sequence(:email) { |n| "example#{n}@example.com" }
    confirmed_at { Time.current }
  end
end
