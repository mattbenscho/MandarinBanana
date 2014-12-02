# -*- coding: utf-8 -*-
namespace :db do
  desc "Feed database with XCZC"
  task populate_xczc: :environment do
    movie_id = Movie.find_by(title: "小城之春").id
    if File.exist?("lib/assets/xczc-imported.txt")
      IO.foreach('lib/assets/xczc-imported.txt') do |line|
        sentence = line.split("\t")[0]
        filename = line.split("\t")[1]
        puts filename, sentence
        entry3 = line.split("\t")[2]
        vocabulary = eval(entry3)
        words = line.split("\t")[3]
        entry5 = line.split("\t")[4]
        entry5.delete!("\n") unless entry5 == ""
        pinyin = eval(entry5)
        @subtitle = Subtitle.find_by(filename: filename)
        if @subtitle.nil?
          Subtitle.create(sentence: sentence, filename: filename, movie_id: movie_id, vocabulary: vocabulary, words: words, pinyin: pinyin)
          puts "created!"
        else
          @subtitle.sentence = sentence        
          @subtitle.movie_id = movie_id
          @subtitle.vocabulary = vocabulary
          @subtitle.words = words
          @subtitle.pinyin = pinyin
          @subtitle.save!
          puts "updated!"
        end
      end
    else
      IO.foreach('lib/assets/xczc-transformed.txt') do |line|
        entry1 = line.split("\t")[0]
        entry2 = line.split("\t")[1]
        entry1.delete!("\n") unless entry1 == ""
        entry2.delete!("\n") unless entry2 == ""
        words = ""
        words = `lib/assets/find_words.rb "#{entry1}"` unless entry1 == ""
        words.delete!("\n") unless words == ""
        vocabulary = ""
        vocabulary = `lib/assets/find_word_definitions.rb "#{words}"` unless words == ""
        vocabulary = eval(vocabulary)
        pinyin = ""
        pinyin = `lib/assets/find_pinyin.rb "#{words}"` unless words == ""
        pinyin = eval(pinyin)
        filename = "xczc-" + entry2
        puts entry1.to_s, filename
        @subtitle = Subtitle.find_by(filename: filename)
        if @subtitle.nil?
          Subtitle.create(sentence: entry1, filename: filename, movie_id: movie_id, vocabulary: vocabulary, words: words, pinyin: pinyin)
          puts "created!"
        else
          @subtitle.sentence = entry1        
          @subtitle.movie_id = movie_id
          @subtitle.vocabulary = vocabulary
          @subtitle.words = words
          @subtitle.pinyin = pinyin
          @subtitle.save!
          puts "updated!"
        end
        File.open("lib/assets/xczc-imported.txt", 'a') do |file|
          file.puts([entry1.to_s, filename.to_s, vocabulary.to_s, words.to_s, pinyin.to_s].join("\t"))
        end
      end
    end
  end
end
