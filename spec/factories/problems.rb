FactoryBot.define do
  factory :problem do
    description { "こんな悩みがあります。" }
    association :user
    created_at { Time.current } 
  end
  trait :problem_yesterday do
    created_at { 1.day.ago }
  end

  trait :problem_one_week_ago do
    created_at { 1.week.ago }
  end

  trait :problem_one_month_ago do
    created_at { 1.month.ago }
  end
end
