# -*- coding: utf-8 -*-
namespace :db do
  desc "Feed database with words"
  task populate_words: :environment do
    Word.delete_all
    lines = File.open('lib/assets/cedict.csv').read
    counter = 0
    lines.each_line do |line|
      line.strip!
      if line[0] == "#"
        next
      end
      counter += 1
      simplified = line.split(" ")[1]
      if simplified.length > 1      
        traditional = line.split(" ")[0]
        translation = line.split("/")[1..-1].join(" / ")
        pinyin = line.split("[")[1].split("]")[0].downcase
        @word = Word.create(traditional: traditional, simplified: simplified, pinyin: pinyin, translation: translation, HSK: 7, frequency: 0)
        puts "counter: \"#{counter}\", traditional: \"#{traditional}\", simplified: \"#{simplified}\", pinyin: \"#{pinyin}\", translation: \"#{translation}\""
      end
    end
  end
end
