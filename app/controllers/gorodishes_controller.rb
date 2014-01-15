class GorodishesController < ApplicationController
  def show
    @gorodish = Gorodish.find(params[:id])
  end

  def index
  end
end
