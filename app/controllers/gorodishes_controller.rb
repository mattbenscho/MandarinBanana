class GorodishesController < ApplicationController
  def show
    @gorodish = Gorodish.find(params[:id])
  end

  def index
    @all_gorodishes = Gorodish.all
  end
end
