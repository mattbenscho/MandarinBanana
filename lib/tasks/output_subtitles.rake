# -*- coding: utf-8 -*-

namespace :db do
  desc "Output subtitles grouped by movie and hsk level"
  task output_subtitles: :environment do
    Movie.all.each do |movie|
      (1..7).each do |hsk|
        Subtitle.where(movie_id: movie.id, HSK: hsk).each do |subtitle|
          # puts subtitle.id
          @sentence_pinyin = ""
          (0..subtitle.sentence.length-1).each do |counter|
            if subtitle.pinyin[counter].length == 1
              @color = "color" + subtitle.pinyin[counter][0].tr('^0-9', '')
            else
              @color = "color"
            end
            @sentence_pinyin += "<div class=\"sentence_pinyin\">"
            @sentence_pinyin += "<span class=\"big_char #{@color}\">#{subtitle.sentence[counter]}</span>"
            @sentence_pinyin += "<br/>"
            subtitle.pinyin[counter].each do |p|
              @sentence_pinyin += "<span class=\"color" + p.tr('^0-9', '') + "\">" + p + "</span><br/>"
            end
            @sentence_pinyin += "</div>"
          end
          @vocabulary = "<table>"
          # puts subtitle.words
          subtitle.vocabulary(hsk).each do |entry| 
            @entries = entry[1].join("<br/>")
            @vocabulary += "<tr><td>#{entry[0]}</td><td>#{@entries}</td></tr>"
          end
          @vocabulary += "</table>"

          puts "#{movie.title}\t#{subtitle.HSK}\t#{subtitle.id}\t#{@sentence_pinyin}\t#{subtitle.filename}\t#{@vocabulary}\t#{subtitle.chinglish}\t#{subtitle.english}"
        end
      end
    end
  end
end
