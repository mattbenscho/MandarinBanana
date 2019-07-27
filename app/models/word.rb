class Word < ActiveRecord::Base
  validates :simplified, length: { minimum: 2 }
  validates :traditional, length: { minimum: 2 }
  validates :pinyin, presence: true
  validates :translation, presence: true

  default_scope { order(Arel.sql('"HSK" ASC'), Arel.sql('frequency DESC')) }
end
