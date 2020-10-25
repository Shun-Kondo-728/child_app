FactoryBot.define do
  factory :post do
    title { "もしこうなったら使えます" }
    recommended { 5 }
    description { "こうやって使います" }
    association :user
  end
end
