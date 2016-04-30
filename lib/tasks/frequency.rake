# -*- coding: utf-8 -*-
namespace :db do
  desc "Go through the frequency file and assign frequencies"
  task frequency: :environment do
    hanzis = File.open('lib/assets/frequency.cropped.csv').read
    hanzis.each_line do |line|
      hanzi = line.split(" ")[0]
      frequency = line.split(" ")[1]
      db_hanzi = Hanzi.find_by(character: hanzi)
      if not db_hanzi.nil?        
        a_count = Hanzi.where('components LIKE ?', "%#{db_hanzi.character}%").count
        db_hanzi.frequency = frequency.to_i + a_count
        db_hanzi.save
        print hanzi + " updated: " + frequency.to_s + "+" + a_count.to_s + "\n"
      else
        print hanzi + " not found!\n"
      end
    end
    Hanzi.where(frequency: nil).each do |h|
      h.frequency = 0
      h.save
    end
  end
end
