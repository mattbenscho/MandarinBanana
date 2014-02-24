class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :subtitle
  belongs_to :hanzi
  default_scope -> { order('created_at ASC') }
  validates :user_id, presence: true
  validates :content, presence: true
end
