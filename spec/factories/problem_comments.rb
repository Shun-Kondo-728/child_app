FactoryBot.define do
  factory :problem_comment do
    user_id { 1 }
    content { "こうした方がいいです。" }
    association :problem
  end
end
