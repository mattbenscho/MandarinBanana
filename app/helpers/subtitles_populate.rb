# on the console: bundle exec rails runner "eval(File.read 'sentences_populate.rb')"

movie=File.open('app/helpers/import.txt').read
movie.each_line do |line|
  line1 = line.split("\t")[0]
  line2 = line.split("\t")[1]
  line3 = line.split("\t")[2]
  Subtitle.create(chars: line1, start: line2, stop: line3)
end
