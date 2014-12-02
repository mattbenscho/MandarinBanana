#!/usr/bin/env ruby

words = ARGV[0]

def fetch_dictline(hanzis)
  open('lib/assets/cedict_uniq.csv') { |f| return f.grep(/^#{hanzis}\t/) }
end

dictionary = []

words.split("|").each do |word|
  dictline = fetch_dictline(word)
  unless dictline.empty?
    definitions = dictline[0].split("\t")[1].split(" // ")
    dictionary.push([word, definitions])
  end    
end

dictionary.push(["---", ["---"]])

words.split("|").each do |word|
  if word.length > 1
    word.each_char do |char|
      dictline = fetch_dictline(char)
      definitions = dictline[0].split("\t")[1].split(" // ")
      dictionary.push([char, definitions])
    end
  end
end

puts dictionary.to_s
