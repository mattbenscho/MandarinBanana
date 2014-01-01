class Movie < ActiveRecord::Base
  validates :youtube_id, presence: true
  validates :title, presence: true
  validates :description, presence: true

  has_many :subtitles, dependent: :destroy
end
