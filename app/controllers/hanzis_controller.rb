class HanzisController < ApplicationController
  def index
    @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
  end

  def show
    @hanzi = Hanzi.find(params[:id])
    @examples = @hanzi.subtitles
    @comments = @hanzi.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "hanzi"
    @topic_id = @hanzi.id
  end
end
