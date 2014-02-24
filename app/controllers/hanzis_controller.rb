class HanzisController < ApplicationController
  def index
    @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
  end

  def show
    @hanzi = Hanzi.find(params[:id])
    @examples = @hanzi.subtitles
  end
end
