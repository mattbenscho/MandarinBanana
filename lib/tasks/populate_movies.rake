namespace :db do
  desc "Create movies"
  task populate_movies: :environment do
    movie = Movie.create(title: "大闹天宫", description: "A lovely film about a monkey king wreaking havoc in heaven.", youtube_id: "9sbeiNqOsyM")
  end
end
