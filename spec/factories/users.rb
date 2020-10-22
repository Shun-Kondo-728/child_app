FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    introduction { "はじめまして。育児初心者ですが、頑張っていきます！" }

    trait :admin do
      admin { true }
    end
  end
end
