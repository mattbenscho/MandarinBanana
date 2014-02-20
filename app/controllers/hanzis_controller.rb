class HanzisController < ApplicationController
  def show
    @hanzi = Hanzi.find(params[:id])
    @examples = @hanzi.subtitles
  end
end
