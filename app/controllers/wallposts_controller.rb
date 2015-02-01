class WallpostsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]

  def new
    @id = params[:id]
    @wallpost = current_user.wallposts.build if signed_in?
  end

  def create
    @wallpost = current_user.wallposts.build(wallpost_params)
    if @wallpost.save
      flash[:success] = "Post created!"
      redirect_to wallposts_url
    else
      render 'static_pages/home'
    end
  end

  def index
    @wallposts = Wallpost.where(parent_id: nil).paginate(page: params[:page])
    @wallpost = current_user.wallposts.build if signed_in?
  end
  
  def destroy
  end

  private

    def wallpost_params
      params.require(:wallpost).permit(:content, :parent_id)
    end

end
