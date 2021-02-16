class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commment
  validates :body, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :date, presence: true
end
