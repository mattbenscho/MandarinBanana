class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :hanzi
  validates :user_id, presence: true
  validates :hanzi_id, presence: true
end
