# -*- coding: utf-8 -*-

namespace :db do
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
      end
      appearances = Hanzi.where('components LIKE ?', "%#{h_char}%")
      app_chars = ""
      if not appearances.nil?
        appearances.each do |app_hanzi|
          unless app_hanzi.nil?
            app_chars += app_hanzi.character
          end
        end
      end
      pds = "<table>"
      for pd in hanzi.pinyindefinitions
        pds += "<tr><td><span class=\"color#{pd.pinyin.gsub(/[^0-9]/, '')}\">#{pd.pinyin}</span></td><td>#{pd.definition}</td></tr>"
      end
      pds += "</table>"
      mnemonics = ""
      for mnemonic in hanzi.mnemonics
        mnemonics += "<div>#{mnemonic.aide.gsub(/[^[:print:]]/,'<br/>')}</div>"
      end
      tags = "HSK#{hanzi.HSK}"
      puts "#{h_char}\t#{h_components}\t#{pds}\t#{app_chars}\t#{mnemonics}\t\t#{tags}"
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
