class Subtitle < ActiveRecord::Base
  serialize :pinyin, JSON
  serialize :words, JSON
  belongs_to :movie
  validates :filename, presence: true, uniqueness: true
  validates :movie_id, presence: true
  has_many :comments, dependent: :destroy
  has_many :reverse_examples, foreign_key: "subtitle_id", class_name: "Example", dependent: :destroy
  has_many :expressions, through: :reverse_examples, source: :expression
  default_scope -> { order(Arel.sql('filename ASC')) }

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

  def find_words
    start_index = 0
    end_index = 3
    length = 4
    @words = Array.new
    while start_index < self.sentence.length
      # puts "start_index: #{start_index}, end_index: #{end_index}"
      if end_index == self.sentence.length
        end_index -= 1
        next
      end
      candidate = self.sentence[start_index..end_index]
      # puts "candidate: #{candidate}"
      length = end_index - start_index + 1
      if length == 1
        @words.push(candidate)
        start_index = start_index + 1
        end_index = start_index + 3
      else
        unless Word.find_by(simplified: candidate).nil?
          @words.push(candidate)
          start_index = start_index + length
          end_index = start_index + 3
        else
          end_index -= 1
        end
      end
    end
    # puts @words
    self.words = @words
    self.save!
  end

  def find_pinyin
    @pinyin = Array.new
    self.words.each do |word|
      if word.length > 1
        lines = Word.find_by(simplified: word).translation.split(" // ")
        @this_pinyin = Array.new
        lines.each do |l|
          @this_pinyin.push(l.gsub(/\].*/, '').downcase[1..-1].split(" "))
        end
        @this_pinyin.transpose.each do |pinyin|
          @pinyin.push(pinyin.sort.uniq)
        end
      else
        @this_pinyin = Array.new
        @hanzi = Hanzi.find_by(character: word)
        unless @hanzi.nil?
          @hanzi.pinyindefinitions.each do |pd|
            @this_pinyin.push("#{pd.pinyin.downcase}")
          end
          @pinyin.push(@this_pinyin.sort.uniq)
        else
          @pinyin.push([word])
        end
      end
      # puts @this_pinyin.to_json
    end
    # puts @pinyin.to_json
    self.pinyin = @pinyin
    self.save!
  end

  def vocabulary(level=1)
    @vocabulary = Array.new
    if self.words.nil?
      return nil
    else
      self.words.each do |word|
        @entry = Array.new
        if word.length > 1
          @words = Word.where(simplified: word)
          unless @words.nil?
            @words.each do |this_word|
              lines = this_word.translation.split(" // ")
              lines.each do |l|
                @entry.push("[#{this_word.pinyin.downcase}] #{l}")
              end
              @vocabulary.push([word, @entry]) unless @vocabulary.include?([word, @entry]) or this_word.HSK < level
            end
          end
        else
          @hanzi = Hanzi.find_by(character: word)
          unless @hanzi.nil?
            Hanzi.find_by(character: word).pinyindefinitions.each do |pd|
              @entry.push("[#{pd.pinyin.downcase}] #{pd.definition}")
            end        
            @vocabulary.push([word, @entry]) unless @vocabulary.include?([word, @entry]) or @hanzi.HSK < level
          end
        end
      end
      return @vocabulary
    end
  end
end
