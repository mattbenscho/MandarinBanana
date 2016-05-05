# -*- coding: utf-8 -*-
namespace :db do
  desc "Assign HSK to words"
  task assign_hsk_to_words: :environment do
    levels = File.open('lib/assets/hskwordlist.csv').read
    levels.each_line do |line|
      level = line.split(",")[0]
      word = line.split(",")[1].chomp!.gsub(/\s+/, "")
      # puts "#{line.chomp!} = #{level} + #{word}"
      @word = Word.find_by(simplified: word)
      if not @word.nil?
        @word.HSK = level
        @word.save!
        puts "#{level}\t#{word}"
      else
        if word.length > 1
          puts "#{level}\t#{word}\tNOT FOUND"
        end
      end
    end
  end
end
