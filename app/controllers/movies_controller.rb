class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    @subtitles = Subtitle.all
    respond_to do |format|
      format.html
      format.csv do 
        headers['Content-Disposition'] = "attachment; filename=\"anki-import-file.csv\""
        headers['Content-Type'] ||= "text/csv"
      end
    end
  end
end
