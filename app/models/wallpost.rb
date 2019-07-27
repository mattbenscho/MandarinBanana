class Wallpost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(Arel.sql('created_at ASC')) }
  validates :user_id, presence: true
  validates :content, presence: true
end
