# -*- coding: utf-8 -*-
namespace :db do
  desc "Find examples for hanzis based on sentences of 小城之春"
  task find_examples_xczc: :environment do
    movie_id = Movie.find_by(title: "小城之春").id
    Subtitle.where(movie_id: movie_id).each do |subtitle| 
      subtitle.sentence.each_char do |char|
        @hanzi = Hanzi.find_by(character: char)
	if !@hanzi.nil?
          @test = Example.find_by(expression_id: @hanzi.id, subtitle_id: subtitle.id)
          if @test.nil?
            Example.create!(expression_id: @hanzi.id, subtitle_id: subtitle.id)
          end
        end
      end
      puts subtitle.sentence
    end
  end
end
