class StrokeordersController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]

  def new
    @hanzi = Hanzi.find(params[:hanzi_id])
    @strokeorder = Strokeorder.new
    @user = current_user
  end

  def create
    @strokeorder = Strokeorder.new(strokeorder_params)
    if @strokeorder.save
      flash[:success] = "Stroke order information saved!"
      redirect_to @strokeorder
    else
      flash[:error] = "Error while trying to save stroke order information!"
      redirect_back_or root_url
    end
  end

  def show
    @strokeorder = Strokeorder.find(params[:id])
    @hanzi = Hanzi.find(@strokeorder.hanzi_id)
    @user = User.find(@strokeorder.user_id)
    @strokes = @strokeorder.strokes
  end

  private

    def strokeorder_params
      params.require(:strokeorder).permit(:hanzi_id, :strokes, :user_id)
    end
end
