# -*- coding: utf-8 -*-
namespace :db do
  desc "Feed database with XCZC"
  task populate_xczc: :environment do
    movie_id = Movie.find_by(title: "小城之春").id
    IO.foreach('lib/assets/xczc-transformed.txt') do |line|
      entry1 = line.split("\t")[0]
      entry2 = line.split("\t")[1]
      entry1.delete!("\n") unless entry1 == ""
      entry2.delete!("\n") unless entry2 == ""
      # # I'm sorry, you'll have to rewrite this!
      # words = ""
      # words.delete!("\n") unless words == ""
      # vocabulary = ""
      # vocabulary = `lib/assets/find_word_definitions.rb "#{words}"` unless words == ""
      # vocabulary = eval(vocabulary)
      # pinyin = ""
      # pinyin = `lib/assets/find_pinyin.rb "#{words}"` unless words == ""
      # pinyin = eval(pinyin)
      # filename = "xczc-" + entry2
      # puts entry1.to_s, filename
      # @subtitle = Subtitle.find_by(filename: filename)
      # if @subtitle.nil?
      #   @new_subtitle = Subtitle.create(sentence: entry1, filename: filename, movie_id: movie_id)
      #   @new_subtitle.find_words
      #   @new_subtitle.set_HSK
      #   puts "created!"
      # else
      #   @subtitle.sentence = entry1        
      #   @subtitle.movie_id = movie_id
      #   @subtitle.vocabulary = vocabulary
      #   @subtitle.find_words
      #   @subtitle.set_HSK
      #   @subtitle.pinyin = pinyin
      #   @subtitle.save!
      #   puts "updated!"
      # end
      # File.open("lib/assets/xczc-imported.txt", 'a') do |file|
      #   file.puts([entry1.to_s, filename.to_s, vocabulary.to_s, words.to_s, pinyin.to_s].join("\t"))
      # end
    end
  end

  desc "Feed database with DNTG"
  task populate_dntg: :environment do
    movie_id = Movie.find_by(title: "大闹天宫").id
    # DRY!
  end

  desc "Feed database with LSJ"
  task populate_lsj: :environment do
    movie_id = Movie.find_by(title: "刘三姐").id
    # DRY!
  end
end
