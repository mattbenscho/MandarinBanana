class HanzisController < ApplicationController
  def show
    @hanzi = Hanzi.find(params[:id])
  end
end
