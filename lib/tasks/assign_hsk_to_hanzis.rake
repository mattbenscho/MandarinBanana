# -*- coding: utf-8 -*-
namespace :db do
  desc "Assign HSK to Hanzis"
  task assign_hsk_to_hanzis: :environment do
    # first, assign each Hanzi the default value of 7
    Hanzi.all.each do |h|
      h.HSK = 7
      h.save!
      puts h.id
    end
    # then, assign the right HSK to each Hanzi
    levels = File.open('lib/assets/hskchars.csv').read
    levels.each_line do |line|
      level = line.split(" ")[0]
      hanzi = line.split(" ")[1]
      @hanzi = Hanzi.find_by(character: hanzi)
      if not @hanzi.nil?
        @hanzi.HSK = level
        @hanzi.save!
        puts "#{level}, #{hanzi}"
      end
    end
  end
end
