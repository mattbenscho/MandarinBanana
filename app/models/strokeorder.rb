class Strokeorder < ActiveRecord::Base
  validates :user_id, presence: true
  validates :hanzi_id, presence: true
  validates :strokes, presence: true
end
