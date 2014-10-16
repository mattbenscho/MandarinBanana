class FeaturedImagesController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :edit, :update, :destroy]

  def index
  end

  def new
    @fimage = FeaturedImage.new
    @image = Image.find(params[:id])
    @mnemonic = @image.mnemonic
    @pd = @mnemonic.pinyindefinition
    @hanzi = @pd.hanzi
  end

  def create
    @fimage = FeaturedImage.new(fimage_params)
    if @fimage.save
      flash[:success] = "Image featured."
    else
      flash[:error] = "Oh noes! Something went wrong!"
    end
    redirect_to root_url
  end

  def show
    @fimage = FeaturedImage.find(params[:id])
    @hanzi = Hanzi.find(@fimage.hanzi_id)
    @examples = @hanzi.subtitles.limit(7)
    @comments = @hanzi.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "hanzi"
    @topic_id = @hanzi.id
    @stroke_order = check_stroke_order(@hanzi.character)
    store_location
  end

  def edit
  end

  def update
  end

  private

    def check_stroke_order(character)      
      if Rails.application.assets.find_asset 'stroke-order-imgs/' + character + '-order.gif'
        return 'stroke-order-imgs/' + character + '-order.gif'
      elsif Rails.application.assets.find_asset 'stroke-order-imgs/' + character + '-red.png'
        return 'stroke-order-imgs/' + character + '-red.png'
      elsif Rails.application.assets.find_asset 'stroke-order-imgs/' + character + '-bw.png'
        return 'stroke-order-imgs/' + character + '-bw.png'
      else
        return nil
      end
    end

    def admin_user
      redirect_to root_url unless current_user.admin? && !current_user.nil?
    end

    def fimage_params
      params.require(:featured_image).permit(:data, :commentary, :mnemonic_aide, :hanzi_id)
    end
end
