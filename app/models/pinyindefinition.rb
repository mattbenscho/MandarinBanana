class Pinyindefinition < ActiveRecord::Base
  belongs_to :hanzi
  validates :pinyin, presence: true
  validates :hanzi_id, presence: true
  validates :gbeginning, presence: true
  validates :gending, presence: true
end
