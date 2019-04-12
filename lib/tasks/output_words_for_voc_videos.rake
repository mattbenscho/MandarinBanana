# -*- coding: utf-8 -*-

namespace :db do
  desc "Output words grouped by hsk level"
  task output_words_for_voc_videos: :environment do
    (1..6).each do |hsk|
      Word.where("\"HSK\" = ?", hsk).reorder(:simplified).each do |word|
        if word.simplified != word.traditional
          traditional = word.traditional
        else
          traditional = ""
        end
        chars = "<table>"
        mnemonics = "<table>"
        word.simplified.each_char do |char|
          hanzi = Hanzi.find_by(character: char)
          chars << "<tr><td class=\"table-hanzi\">#{char}</td><td><table>"
          hanzi.pinyindefinitions.each do |pd|
            chars << "<tr><td>#{pd.pinyin}</td><td>#{pd.definition}</td></tr>"
          end
          chars << "</table></td></tr>"
          mnemonics << "<tr><td class=\"table-hanzi\">#{char}</td><td>"
          hanzi.mnemonics.each do |mnemonic|
            mnemonics << "<div>#{mnemonic.aide.gsub(/\n/, "<br/>")}</div>"
          end
        end
        chars << "</table>"
        mnemonics << "</table>"


        colored = "<div class=\"word-characters\">"
        word.simplified.each_char.with_index do |c, i|
          pinyin = word.pinyin.split(" ")[i]
          colorclass = ""
          unless pinyin.nil?
            colornumber = pinyin[-1]
            if colornumber =~ /[1-5]/
              colorclass = "color" + colornumber
            end
          end
          colored << "<div style=\"display:inline-block;\" class=\"center #{colorclass}\">"
          colored << "<span class=\"big-char hanzi\">#{c}</span><br/><span>#{pinyin}</span></div>"
        end
        colored << "</div>"

        puts "#{word.simplified}\t#{traditional}\t#{word.HSK}\t#{word.translation}\t#{word.pinyin}\t#{colored}\t#{chars}\t#{mnemonics}\t#{word.id}"
      end
    end
  end
end


