class Mnemonic < ActiveRecord::Base
  validates :aide, presence: true
  validates :user_id, presence: true
  belongs_to :user
  belongs_to :pinyindefinition
  belongs_to :gorodish
  has_many :images, dependent: :destroy
end
