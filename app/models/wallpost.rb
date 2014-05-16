class Wallpost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at ASC') }
  validates :user_id, presence: true
  validates :content, presence: true
end
