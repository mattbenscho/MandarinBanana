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
end
