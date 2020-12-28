FactoryBot.define do
  factory :problem do
    description { "こんな悩みがあります。" }
    association :user
  end
end
