class SubtitlesController < ApplicationController
  def new
  end

  def show
    @subtitle = Subtitle.find(params[:id])
  end

  def embed
    @subtitle = Subtitle.find(params[:id])
    render layout: false
  end
end

