class SubtitlesController < ApplicationController
  def show
    @subtitle = Subtitle.find(params[:id])
    @comments = @subtitle.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "subtitle"
    @topic_id = @subtitle.id
    @vocabulary = @subtitle.vocabulary
  end
end

