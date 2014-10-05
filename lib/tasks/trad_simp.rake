# -*- coding: utf-8 -*-
namespace :db do
  desc "Build the trad_simp relationships"
  task build_trad_simp_relationships: :environment do
    dict = File.open('lib/assets/cedict.csv').read
    dict.each_line do |line|
      trad = line.split(" ")[0]
      simp = line.split(" ")[1]
      if !trad.nil? && !simp.nil?
        if trad.size == 1 && simp.size == 1
          if trad != simp
            print trad, simp, " - "
            @trad = Hanzi.find_by(character: trad)
            @simp = Hanzi.find_by(character: simp)
            if !@trad.nil? && !@simp.nil?
              @simplified = Simplified.where(trad_id: @trad.id).where(simp_id: @simp.id).first
              if @simplified.nil?
                @simplified = Simplified.new(trad_id: @trad.id, simp_id: @simp.id)
                @simplified.save
              else
                puts "Record already exists."
              end
            else
              puts "Either @trad or @simp empty!"
            end
          end
        end
      end
    end
    puts ""
  end
end
