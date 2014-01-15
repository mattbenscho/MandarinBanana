namespace :db do
  desc "Feed database with Lola"
  task populate_lola: :environment do
    movie_id = Movie.find_by(title: "Lola Rennt").id
    movie = File.open('lib/assets/import_lola.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with Laura"
  task populate_laura: :environment do
    movie_id = Movie.find_by(title: "Lauras Stern").id
    movie = File.open('lib/assets/import_laura.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with DNTG"
  task populate_dntg: :environment do
    movie_id = Movie.find_by(title: "大闹天宫").id
    movie = File.open('lib/assets/import_dntg.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with BWBJ"
  task populate_bwbj: :environment do
    movie_id = Movie.find_by(title: "霸王别姬").id
    movie = File.open('lib/assets/import_bwbj.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with HTD"
  task populate_htd: :environment do
    movie_id = Movie.find_by(title: "黄土地").id
    movie = File.open('lib/assets/import_htd.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with SEJIE"
  task populate_sejie: :environment do
    movie_id = Movie.find_by(title: "色，戒").id
    movie = File.open('lib/assets/import_sejie.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with HUOZHE"
  task populate_huozhe: :environment do
    movie_id = Movie.find_by(title: "活着").id
    movie = File.open('lib/assets/import_huozhe.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end

  desc "Feed database with WHCL"
  task populate_whcl: :environment do
    movie_id = Movie.find_by(title: "卧虎藏龙").id
    movie = File.open('lib/assets/import_whcl.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line3 = line.split("\t")[2]
      Subtitle.create(sentence: line1, start: line2, stop: line3, movie_id: movie_id)
    end
  end
end
