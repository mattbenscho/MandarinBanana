class GorodishesController < ApplicationController
  def show
    @gorodish = Gorodish.find(params[:id])
    store_location
  end

  def index
    @all_gorodishes = Gorodish.all
    store_location
  end
end
