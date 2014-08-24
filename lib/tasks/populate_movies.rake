namespace :db do
  desc "Create movies"
  task populate_movies: :environment do
    movie = Movie.create(title: "小城之春", description: "Spring in a Small Town")
  end
end
