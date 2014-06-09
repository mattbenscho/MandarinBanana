class PinyindefinitionsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :index, :edit, :update, :destroy]

  def new
    @pinyindefinition = Pinyindefinition.new
    @hanzi_id = params[:hanzi_id]
  end

  def create
    @pinyindefinition = Pinyindefinition.new(pinyindefinition_params)
    if @pinyindefinition.save
      flash[:success] = "Pinyindefinition created!"
      redirect_to Hanzi.find(@pinyindefinition.hanzi_id)
    else
      render 'new'
    end    
  end

  def edit
    @pinyindefinition = Pinyindefinition.find(params[:id])
  end

  def update
    @pinyindefinition = Pinyindefinition.find(params[:id])
    if @pinyindefinition.update_attributes(pinyindefinition_params)
      flash[:success] = "Pinyindefinition updated!"
      redirect_to Hanzi.find(@pinyindefinition.hanzi_id)
    else
      render 'edit'
    end
  end

  def destroy
    Pinyindefinition.find(params[:id]).destroy
    flash[:success] = "Pinyindefinition deleted!"
    redirect_to hanzis_url
  end

  private

    def pinyindefinition_params
      params.require(:pinyindefinition).permit(:pinyin, :definition, :hanzi_id, :gbeginning, :gending)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
