class Subtitle < ActiveRecord::Base
  serialize :vocabulary, JSON
  serialize :pinyin, JSON
  belongs_to :movie
  validates :filename, presence: true, uniqueness: true
  validates :movie_id, presence: true
  has_many :comments, dependent: :destroy
  has_many :reverse_examples, foreign_key: "subtitle_id", class_name: "Example", dependent: :destroy
  has_many :expressions, through: :reverse_examples, source: :expression
  default_scope -> { order('filename ASC') }

  def set_HSK
    @HSK = 1
    if self.sentence == ""
      @HSK = 0
    end
    self.sentence.each_char do |char|
      @hanzi = Hanzi.find_by(character: char)
      if not @hanzi.nil?
        if @hanzi.HSK > @HSK
          @HSK = @hanzi.HSK
        end
      end
    end
    self.HSK = @HSK
    self.save!
  end
end
