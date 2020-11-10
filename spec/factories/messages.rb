FactoryBot.define do
  factory :message do
    content { "よろしくお願いします！" }
    association :talk
    association :user
  end
end
