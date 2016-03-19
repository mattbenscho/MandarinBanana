# -*- coding: utf-8 -*-
namespace :db do
  desc "Assign HSK to words"
  task assign_hsk_to_words: :environment do
    # first, assign each Hanzi the default value of 7
    # Word.all.each do |w|
    #   w.HSK = 7
    #   w.save!
    #   puts w.id
    # end
    # then, assign the right HSK to each Hanzi
    levels = File.open('lib/assets/hskwordlist.csv').read
    levels.each_line do |line|
      level = line.split(",")[0]
      word = line.split(",")[1].chomp!.gsub(/\s+/, "")
      # puts "#{line.chomp!} = #{level} + #{word}"
      @word = Word.find_by(characters: word)
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
