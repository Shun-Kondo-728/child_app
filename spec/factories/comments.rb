FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "すごい参考になりました。ありがとうございます。" }
    association :post
  end
end
