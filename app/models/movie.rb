class Movie < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  has_many :subtitles, dependent: :destroy
end
