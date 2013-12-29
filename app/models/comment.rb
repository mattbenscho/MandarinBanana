class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :subtitle
  default_scope -> { order('created_at ASC') }
  validates :user_id, presence: true
  validates :subtitle_id, presence: true
  validates :content, presence: true
end
