class Hanzi < ActiveRecord::Base
  validates :character, presence: true, length: { maximum: 1 }
  has_many :pinyindefinitions, dependent: :destroy  
end
