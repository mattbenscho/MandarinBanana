class SubtitlesController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @subtitle = Subtitle.find(params[:id])
    @comments = @subtitle.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "subtitle"
    @topic_id = @subtitle.id
  end
end

