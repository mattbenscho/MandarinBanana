#!/usr/bin/env ruby

sentence = ARGV[0]

def word_exists(hanzis)
  open('lib/assets/word_list.csv') { |f| return f.grep(/^#{hanzis}$/).any? }
end

s_array = sentence.split("")
current_index = 0
max_index = s_array.count

words = []

while current_index < max_index do
  length = 3
  while length >= 0 do
    while current_index + length >= max_index
      length -= 1
    end
    word = s_array[current_index..current_index+length].join
    if length == 0
      words.push(word)
      break
    end
    if word_exists(word)
      words.push(word)
      current_index += length
      break
    end
    length -= 1
  end
  current_index += 1
end

puts words.join("|")
