# -*- coding: utf-8 -*-
namespace :db do
  desc "Run several tasks to feed the database"
  task build_database: [:populate_movies, :populate_hanzis, :populate_gorodishes, :populate_dntg, :find_examples_dntg]
end
