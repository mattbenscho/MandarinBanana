class Hanzi < ActiveRecord::Base
  validates :character, presence: true, length: { maximum: 1 }
  has_many :pinyindefinitions, dependent: :destroy  
  has_many :examples, foreign_key: "expression_id", dependent: :destroy
  has_many :subtitles, through: :examples, source: :subtitle
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :simplifieds, foreign_key: "trad_id", dependent: :destroy
  has_many :simplified_variants, through: :simplifieds, source: :simp
  has_many :traditionals, foreign_key: "simp_id", class_name: "Simplified", dependent: :destroy
  has_many :traditional_variants, through: :traditionals, source: :trad
  has_many :featured_images

  default_scope { order('character') }

  def simplified_by?(other_hanzi)
    simplifieds.find_by(simp_id: other_hanzi.id)
  end

  def simplify_by!(other_hanzi)
    simplifieds.create!(simp_id: other_hanzi.id)
  end
end
