# -*- coding: utf-8 -*-

# def truncate s, length = 100, ellipsis = '...'
#   if s.length > length
#     s.to_s[0..length].gsub(/[^\w]\w+\s*$/, ellipsis)
#   else
#     s
#   end
# end

namespace :db do
  def get_table(hanzi)
      pds = "<table>"
      for pd in hanzi.pinyindefinitions
        pds += "<tr>"
        pds += "<td class=\"color#{pd.pinyin.gsub(/[^0-9]/, '')}\"><div><span class=\"hanzi\">#{hanzi.character}<br/></span><span class=\"pinyin\">#{pd.pinyin}</span></div></td>"
        pds += "<td>"
        pds += "<div class=\"pydefinition\">#{pd.definition}</div>"
        if pd.mnemonics.any?
          pds += "<div class=\"mnemonics\">"
          for mnemonic in pd.mnemonics
            pds += "<div class=\"mnemonic\">#{mnemonic.aide.gsub(/[^[:print:]]+/,'<br/><br/>')}</div>"
            for image in mnemonic.images
              pds += "<img class=\"mimage\" src=\"#{image.id}.png\">"
            end
          end
          pds += "</div>"
        end 
        pds += "</td></tr>"
      end
      pds += "</table>"
      return pds
  end
  
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


