class FeaturedImage < ActiveRecord::Base
  validates :data, presence: true
  validates :mnemonic_aide, presence: true
  validates :hanzi_id, presence: true
  validates :pinyindefinition_id, presence: true
  validates :commentary, presence: true
  default_scope -> { order(Arel.sql('created_at ASC')) }
  belongs_to :hanzi
  belongs_to :pinyindefinition

  has_many :examples, through: :hanzi
  has_many :subtitles, through: :examples


  def next
    FeaturedImage.where("created_at > ?", self.created_at).first
  end

  def previous
    FeaturedImage.where("created_at < ?", self.created_at).last
  end
end
