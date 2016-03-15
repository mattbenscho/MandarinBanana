class Word < ActiveRecord::Base
  validates :characters, length: { minimum: 2 }, uniqueness: true
  validates :translation, presence: true
end
