# -*- coding: utf-8 -*-

def truncate s, length = 100, ellipsis = '...'
  if s.length > length
    s.to_s[0..length].gsub(/[^\w]\w+\s*$/, ellipsis)
  else
    s
  end
end

namespace :db do
  desc "Output subtitles grouped by movie and hsk level"
  task output_subtitles: :environment do
    Movie.all.each do |movie|
      (1..7).each do |hsk|
        Subtitle.where(movie_id: movie.id, HSK: hsk).each do |subtitle|
          @vocabulary = "<table>"
          # puts subtitle.words
          subtitle.words.gsub(/[a-zA-Z0-9!?\.,！？\-。，"“‘、]/, '').split("|").each do |word|
            # puts word
            if word.length > 1
              @word = Word.find_by(characters: word)
              unless @word.nil?
                @definition = truncate @word.translation
                @vocabulary += "<tr><td>#{@word.characters}</td><td>#{@definition}</td></tr>"
              end    
            else
              @hanzi = Hanzi.find_by(character: word)
              unless @hanzi.nil?
                @hanzi.pinyindefinitions.each do |pd|
                  @definition = truncate pd.definition
                  @vocabulary += "<tr><td>#{@hanzi.character}</td><td>[#{pd.pinyin}] #{@definition}</td></tr>"
                end
              end
            end
          end
          @vocabulary += "</table>"

          puts "#{movie.title}\t#{subtitle.HSK}\t#{subtitle.id}\t#{subtitle.sentence}\t#{subtitle.filename}\t#{@vocabulary}"

        end
      end
    end
  end
end
