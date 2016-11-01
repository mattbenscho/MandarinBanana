class Strokeorder < ActiveRecord::Base
  validates :user_id, presence: true
  validates :hanzi_id, presence: true
  validates :strokes, presence: true, length: { maximum: 2000000 }
  belongs_to :user
  belongs_to :hanzi
end
