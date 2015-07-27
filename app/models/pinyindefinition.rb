class Pinyindefinition < ActiveRecord::Base
  belongs_to :hanzi
  validates :pinyin, presence: true
  validates :hanzi_id, presence: true
  validates :definition, presence: true
  has_many :mnemonics, dependent: :destroy
  has_many :featured_images

  def gorodishes
    Gorodish.where(element: [self.gbeginning, self.gending])
  end
end
