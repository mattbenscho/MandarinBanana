# -*- coding: utf-8 -*-
namespace :db do
  desc "Feed database with XCZC"
  task populate_xczc: :environment do
    movie_id = Movie.find_by(title: "小城之春").id
    IO.foreach('lib/assets/import_xczc.txt') do |line|
      entry1 = line.split("\t")[0]
      entry2 = line.split("\t")[1]
      entry3 = line.split("\t")[2]
      entry3.delete!("\n") unless entry3.nil?
      vocabulary = eval(entry3) unless entry3.nil?
      puts entry1#, vocabulary.to_s
      filename = "xczc-" + entry2
      @subtitle = Subtitle.find_by(filename: filename)
      if @subtitle.nil?
        Subtitle.create(sentence: entry1, filename: filename, movie_id: movie_id, vocabulary: vocabulary)
      else
        @subtitle.sentence = entry1
        @subtitle.movie_id = movie_id
        @subtitle.vocabulary = vocabulary
        @subtitle.save!
      end
    end
  end
end
