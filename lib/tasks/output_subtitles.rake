# -*- coding: utf-8 -*-

# def truncate s, length = 100, ellipsis = '...'
#   if s.length > length
#     s.to_s[0..length].gsub(/[^\w]\w+\s*$/, ellipsis)
#   else
#     s
#   end
# end

namespace :db do
  desc "Output subtitles grouped by movie and hsk level"
  task output_subtitles: :environment do
    Movie.all.each do |movie|
      (1..7).each do |hsk|
        Subtitle.where(movie_id: movie.id, HSK: hsk).each do |subtitle|
          # puts subtitle.id
          @sentence_pinyin = ""
          (0..subtitle.sentence.length-1).each do |counter|
            @sentence_pinyin += "<div class=\"sentence_pinyin\">"
            @sentence_pinyin += "<span class=\"big_char\">#{subtitle.sentence[counter]}</span>"
            @sentence_pinyin += "<br/>"
            @sentence_pinyin += subtitle.pinyin[counter].join("<br/>")
            @sentence_pinyin += "</div>"
          end
          @vocabulary = "<table>"
          # puts subtitle.words
          subtitle.vocabulary(hsk).each do |entry| 
            @entries = entry[1].join("<br/>")
            @vocabulary += "<tr><td>#{entry[0]}</td><td>#{@entries}</td></tr>"
          end
          @vocabulary += "</table>"

          puts "#{movie.title}\t#{subtitle.HSK}\t#{subtitle.id}\t#{@sentence_pinyin}\t#{subtitle.filename}\t#{@vocabulary}"
        end
      end
    end
  end
end
