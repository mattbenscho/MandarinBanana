# -*- coding: utf-8 -*-
namespace :db do
  desc "Feed database with Gorodishes"
  task populate_gorodishes: :environment do
    gorodishes = File.open('lib/assets/prepared-gorodishes.csv').read
    gorodishes.each_line do |line|
      @element = line.split("\t")[0].chomp
      Gorodish.create(element: @element)
    end
  end
end
