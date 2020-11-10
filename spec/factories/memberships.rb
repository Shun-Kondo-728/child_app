FactoryBot.define do
  factory :membership do
    association :talk
    association :user
  end
end
