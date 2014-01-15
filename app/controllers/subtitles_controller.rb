class SubtitlesController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @subtitle = Subtitle.find(params[:id])
    @comments = @subtitle.comments
    @comment = current_user.comments.build if signed_in?
  end

  def embed
    @subtitle = Subtitle.find(params[:id])
    render layout: false
  end

  def embed_comments
    @subtitle = Subtitle.find(params[:id])
    @comments = @subtitle.comments
    render layout: false
  end
end

