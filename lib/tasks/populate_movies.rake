namespace :db do
  desc "Create movies"
  task populate_movies: :environment do
    movie = Movie.create(title: "大闹天宫", description: "A movie.", youtube_id: "N/A")
  end
end
