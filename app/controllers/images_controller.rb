class ImagesController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @mnemonic = Mnemonic.find(params[:id])
    @image = Image.new
    if !@mnemonic.pinyindefinition_id.nil?
      @pydef = Pinyindefinition.find(@mnemonic.pinyindefinition_id)
      @hanzi = Hanzi.find(@pydef.hanzi_id)
    else
      @gorodish = Gorodish.find(@mnemonic.gorodish_id)
    end
  end

  def create
    @image = current_user.images.build(image_params)
    @mnemonic = Mnemonic.find(@image.mnemonic_id)
    if !@mnemonic.pinyindefinition_id.nil?
      @pydef = Pinyindefinition.find(@mnemonic.pinyindefinition_id)
      @hanzi = Hanzi.find(@pydef.hanzi_id)
    else
      @gorodish = Gorodish.find(@mnemonic.gorodish_id)
    end
    if @image.save
      flash[:success] = "Image saved!"
    else
      flash[:error] = "Image was not saved."      
    end
    if !@mnemonic.pinyindefinition_id.nil?
      redirect_to @hanzi
    else
      redirect_to @gorodish
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:success] = "Image deleted."
    redirect_back_or mnemonics_url
  end

  private

    def image_params
      params.require(:image).permit(:data,:mnemonic_id)
    end
    
    def correct_user
      @user = User.find(Image.find(params[:id]).user_id)
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end
end
