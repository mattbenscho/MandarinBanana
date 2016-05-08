# -*- coding: utf-8 -*-
namespace :db do
  desc "Go through the subtlex frequency file and assign frequencies"
  task frequency_words: :environment do
    words = File.open('lib/assets/subtlex_words.csv').read
    words.each_line do |line|
      word = line.split("\t")[0]
      if word.length == 1
        next
      end
      frequency = line.split("\t")[1]
      db_word = Word.where(simplified: word)
      if not db_word.nil? 
        db_word.each do |w|
          w.frequency = frequency.to_i
          w.save
        end
        print word + " updated: " + frequency.to_s
      else
        print word + " not found!\n"
      end
    end
  end
end
