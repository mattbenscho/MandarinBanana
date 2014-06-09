class Pinyindefinition < ActiveRecord::Base
  belongs_to :hanzi
  validates :pinyin, presence: true
  validates :hanzi_id, presence: true
  has_many :mnemonics, dependent: :destroy
end
