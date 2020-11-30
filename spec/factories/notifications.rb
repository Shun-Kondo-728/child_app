FactoryBot.define do
  factory :notification do
    visiter_id { 1 }
    visited_id { 2 }
    post_id { 3 }
    comment_id nil
    action { "like" }
    checked false
  end
end
