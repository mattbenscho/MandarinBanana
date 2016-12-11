# -*- coding: utf-8 -*-

namespace :db do
  def get_table(hanzi)
      pds = "<table>"
      for pd in hanzi.pinyindefinitions
        pds += "<tr>"
        pds += "<td class=\"color#{pd.pinyin.gsub(/[^0-9]/, '')}\"><div><span class=\"hanzi\">#{hanzi.character}<br/></span><span class=\"pinyin\">#{pd.pinyin}</span></div></td>"
        pds += "<td>"
        pds += "<div class=\"pydefinition\">#{pd.definition}</div>"
        pds += "<div class=\"mnemonics\">"
        for mnemonic in pd.mnemonics
          pds += "<div class=\"mnemonic\">#{mnemonic.aide.gsub(/[^[:print:]]+/,'<br/><br/>')}</div>"
          for image in mnemonic.images
            pds += "<img class=\"mimage\" src=\"#{image.id}.png\">"
          end
        end
        pds += "</div>"
        pds += "</td>"
        pds += "</tr>"
      end
      pds += "</table>"
      return pds
  end
  
  def process_hanzi(hanzi)
    if hanzi.nil?
      return
    end
    if @processed.include? hanzi.character
      return
    end
    if not hanzi.components.empty?
      hanzi.components.each_char do |component|
        process_hanzi(Hanzi.find_by(character: component))
      end
    end
    if hanzi.mnemonics.any?
      h_char = hanzi.character
      h_components = "#{h_char} = " + hanzi.components.split("").join(" + ")
      if hanzi.components.empty?
        h_components = ""
      else
        h_components = "<div class=\"hanzi\">#{h_components}</div>"
        for hanzi_component in hanzi.components.split("")
          this_hanzi = Hanzi.find_by(character: hanzi_component)
          unless this_hanzi.nil?
            h_components += get_table(this_hanzi)
          end
        end
      end
      pds = get_table(hanzi)
      tags = "HSK#{hanzi.HSK}"
      puts "#{h_char}\t#{h_components}\t#{pds}\t#{tags}"
      @processed += h_char
    end
  end
  
  desc "Output hanzis for Anki deck"
  task output_anki: :environment do
    @processed = ""
    Hanzi.joins(:mnemonics).uniq.all.each do |hanzi|
      process_hanzi(hanzi)
    end
  end
end
