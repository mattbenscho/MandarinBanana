# -*- coding: utf-8 -*-
namespace :db do
  desc "Assign HSK to words"
  task assign_hsk_to_words: :environment do
    levels = File.open('lib/assets/hskwordlist.csv').read
    levels.each_line do |line|
      level = line.split(",")[0]
      word = line.split(",")[1].chomp!.gsub(/\s+/, "")
      # puts "#{line.chomp!} = #{level} + #{word}"
      @words = Word.where(simplified: word)
      if not @words.nil?
        @words.each do |word|
          word.HSK = level
          word.save!
          puts "#{level}\t#{word.simplified}"
        end
      else
        if word.length > 1
          puts "#{level}\t#{word}\tNOT FOUND"
        end
      end
    end
  end
end
