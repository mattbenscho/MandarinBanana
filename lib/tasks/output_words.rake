# -*- coding: utf-8 -*-

namespace :db do
  desc "Output words grouped by hsk level"
  task output_words: :environment do
    done = Array.new
    (1..6).each do |hsk|
      Word.where("\"HSK\" = ?", hsk).each do |word|        

        if done.include? word.simplified
          next
        end

        # getting the traditional version if there is one
        if word.simplified != word.traditional
          traditional = word.traditional
        else
          traditional = ""
        end

        char_hsk = 0

        # getting the individual chars
        chars = "<div class=\"chars\">"
        word.simplified.each_char do |char|
          this_char = Hanzi.find_by(character: char)
          if this_char.HSK > char_hsk then
            char_hsk = this_char.HSK
          end
                               
          unless this_char.nil?
            chars += get_table(this_char)
          end
        end
        chars += "</div>"

        # getting all translations
        translations = "<ul class=\"translations\">"
        Word.where(simplified: word.simplified).each do |other_word|
          translations += "<li><span class=\"word_pinyin\">[#{other_word.pinyin}]</span> #{other_word.translation}</li>"
        end
        translations += "</ul>"
        
        done.push(word.simplified)

        puts "#{word.simplified}\t#{traditional}\tHSK#{word.HSK} char_HSK#{char_hsk}\t#{chars}\t#{translations}\t#{word.id}"
      end
    end
  end
end


