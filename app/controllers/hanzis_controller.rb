class HanzisController < ApplicationController
  def index
    if params[:hanzi_search]
      @hanzi = Hanzi.find_by(character: "#{params[:hanzi_search]}")
      if @hanzi.nil? then
        @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
      else
        redirect_to hanzi_url(@hanzi.id)
      end
    else
      @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
    end
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
