namespace :db do
  desc "Feed database with XCZC"
  task populate_xczc: :environment do
    movie_id = Movie.find_by(title: "小城之春").id
    movie = File.open('lib/assets/import_xczc.txt').read
    movie.each_line do |line|
      line1 = line.split("\t")[0]
      line2 = line.split("\t")[1]
      line2.delete!("\n")
      filename = "xczc-" + line2
      Subtitle.create(sentence: line1, filename: filename, movie_id: movie_id)
    end
  end
end
