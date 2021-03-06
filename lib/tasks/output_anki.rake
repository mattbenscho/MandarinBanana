# -*- coding: utf-8 -*-

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
            pds += "<div class=\"mnemonic\">#{mnemonic.aide.gsub(/[^[:print:]]+/,'<br/><br/>')} <span class=\"authorattribution\">(#{mnemonic.user.name})</span></div>"
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

      image_ids = []
      hanzi.images.each do |image|
        image_ids.push(image.id)
      end

      hanzi.pinyindefinitions.each do |pd|
        pd.gorodishes.each do |gorodish|
          gorodish.mnemonics.each do |mnemonic|
            mnemonic.images.each do |image|
              image_ids.push(image.id)
            end
          end
        end   
      end

      for hanzi_component in hanzi.components.split("")
        this_hanzi = Hanzi.find_by(character: hanzi_component)
        unless this_hanzi.nil?
          this_hanzi.images.each do |image|
            image_ids.push(image.id)
          end          
        end
      end

      images = ""
      for id in image_ids.uniq
        images += "<img class=\"mimage\" src=\"#{id}.png\"> "
      end

      appearances = ""
      children = Hanzi.where('components LIKE ?', "%#{hanzi.character}%")
      for child in children
        appearances += "<span><a href=\"http://www.mandarinbanana.com/hurl/#{child.character}\">#{child.character}</a></span> "
      end

      words_html = "<table class=\"words-table\">"
      if hanzi.simplifieds.any?
        words = Word.where('traditional LIKE ?', "%#{hanzi.character}%").limit(30)
      else
        words = Word.where('simplified LIKE ?', "%#{hanzi.character}%").limit(30)
      end
      words.each do |w|
        words_html += "<tr><td class=\"word-characters\">"
        w.simplified.each_char.with_index do |c, i|
          pinyin = w.pinyin.split(" ")[i]
	  colorclass = ""
	  unless pinyin.nil?
	    colornumber = pinyin[-1]
 	    if colornumber =~ /[1-5]/
	      colorclass = "color" + colornumber
	    end
          end
          words_html += "<div style=\"display:inline-block;\" class=\"center #{colorclass}\">"
          words_html += "<a href=\"http://www.mandarinbanana.com/hurl/#{c}\" class=\"colorclass hanzi\">#{c}</a>"
	  words_html += "<br/>"
	  words_html += "#{pinyin}"
          words_html += "</div> "
        end
        words_html += "</td><td class=\"word-translation\">#{w.translation}"
        if w.HSK < 7
	  words_html += " (HSK level #{w.HSK})"
        end
        words_html += "</td>"
        words_html += "</tr>"          
      end
      words_html += "</table>"

      examples = hanzi.subtitles.limit(20)
      subtitles_html = "<ul class=\"subtitles-list\">"
      for subtitle in examples do
        subtitles_html += "<li><a class=\"hanzi\" href=\"http://www.mandarinbanana.com/subtitles/#{subtitle.id}\">#{subtitle.sentence}</a></li> "
      end
      subtitles_html += "</ul>"

      puts "#{h_char}\t#{h_components}\t#{pds}\t#{images}\t#{appearances}\t#{subtitles_html}\t#{words_html}\t#{tags}"
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
