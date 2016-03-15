# -*- coding: utf-8 -*-
namespace :db do
  desc "Feed database with words"
  task populate_words: :environment do
    lines = File.open('lib/assets/cedict_uniq.csv').read
    counter = 0
    lines.each_line do |line|
      puts counter
      counter += 1
      word = line.split("\t")[0]
      if word.length > 1      
        translation = line.split("\t")[1]
        @word = Word.create(characters: word, translation: translation)
      end
    end
  end
end
