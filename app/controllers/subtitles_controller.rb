class SubtitlesController < ApplicationController
  def new
  end

  def show
    @subtitle = Subtitle.find(params[:id])
  end
end

