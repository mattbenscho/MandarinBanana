# -*- coding: utf-8 -*-
namespace :db do
  desc "Assign HSK to subtitles"
  task assign_hsk_to_subtitles: :environment do
    Subtitle.all.each do |subtitle|
      subtitle.set_HSK
      puts "#{subtitle.sentence} -> #{subtitle.HSK}"
    end
  end
end
