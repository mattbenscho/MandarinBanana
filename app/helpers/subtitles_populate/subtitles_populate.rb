# using bash from app root: bundle exec rails runner "eval(File.read 'app/helpers/subtitles_populate/subtitles_populate.rb')"

movie=File.open('app/helpers/subtitles_populate/import_lola.txt').read
movie.each_line do |line|
  line1 = line.split("\t")[0]
  line2 = line.split("\t")[1]
  line3 = line.split("\t")[2]
  Subtitle.create(sentence: line1, start: line2, stop: line3)
end
