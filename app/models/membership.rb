class Membership < ApplicationRecord
  belongs_to :talk
  belongs_to :user
  validates :user_id, uniqueness: { scope: :talk_id }
end
