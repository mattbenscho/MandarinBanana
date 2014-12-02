#!/usr/bin/env ruby

words = ARGV[0]

def fetch_pinyin(hanzis)
  dictline = ""
  open('lib/assets/cedict_uniq.csv') do |f|
    dictline = f.grep(/^#{hanzis}\t/)
  end
  if dictline.empty?
    return []
  else
    pinyins = []
    dictline[0].to_s.downcase.split("\t")[1].split(" // ").each do |d|
      pinyins.push(d.gsub(/].*/, "]").gsub(/[\[\]]/, "").split(" "))
    end
    return pinyins
  end
end

pinyin_dict = Array.new(words.delete("|").length, [])

index = 0
words.split("|").each do |word|
  pinyin = fetch_pinyin(word)
  # puts "### " + word + ", " + pinyin.to_s + " ###"
  if pinyin.empty?
    pinyin_dict[index] = []
  else
    pinyin.each do |word_pinyin|
      counter = 0
      word_pinyin.each do |hanzi_pinyin|
        # puts hanzi_pinyin + " / " + (index+counter).to_s
        # puts pinyin_dict[index+counter].to_s
        pinyin_dict[index+counter] = [pinyin_dict[index+counter], hanzi_pinyin].flatten.uniq
        counter += 1
      end
    end
  end    
  index += word.length
end

puts pinyin_dict.to_s
