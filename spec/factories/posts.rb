FactoryBot.define do
  factory :post do
    title { "もしこうなったら使えます" }
    recommended { 5 }
    description { "こうやって使います" }
    association :user
    created_at { Time.current }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end
end
