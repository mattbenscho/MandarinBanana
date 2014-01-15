class ImagesController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @mnemonic = Mnemonic.find(params[:id])
    @image = Image.new
  end

  def show
    @image = Image.find(params[:id])
  end

  def create
    @image = current_user.images.build(image_params)
    if @image.save
      flash[:success] = "Image saved!"
      redirect_to @image
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def image_params
      params.require(:image).permit(:data,:mnemonic_id)
    end
    
end
