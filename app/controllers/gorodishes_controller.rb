class GorodishesController < ApplicationController
  def show
    @gorodish = Gorodish.find(params[:id])
    @appearances = Pinyindefinition.where(["gbeginning = ? or gending = ?", @gorodish.element, @gorodish.element])
    store_location
  end

  def index
    @all_gorodishes = Gorodish.all
    store_location
  end
end
