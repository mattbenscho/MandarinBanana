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
        db_hanzi.frequency = frequency
        db_hanzi.save
        print hanzi + " updated: " + db_hanzi.frequency.to_s + "\n"
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
