# -*- coding: utf-8 -*-

namespace :db do  
  desc "Output stories for the pleco dictionary"
  task output_pleco_stories: :environment do
    hanzis = Hanzi.joins(:mnemonics).uniq.all
    hanzis.each do |hanzi|
      stories = []
      hanzi.mnemonics.each do |mnemonic|
        stories.push(mnemonic.aide)
      end
      stories = stories.join(" ### ")
      puts "#{hanzi.character}\t#{hanzi.mnemonics.first.pinyindefinition.pinyin}\t#{stories}"
    end
  end
end


