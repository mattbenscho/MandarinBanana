class Hanzi < ActiveRecord::Base
  validates :character, presence: true, length: { maximum: 1 }
  has_many :pinyindefinitions, dependent: :destroy  
  has_many :examples, foreign_key: "expression_id", dependent: :destroy
  has_many :subtitles, through: :examples, source: :subtitle
  has_many :comments, dependent: :destroy
end
