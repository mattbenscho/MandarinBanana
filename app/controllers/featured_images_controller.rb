# -*- coding: utf-8 -*-
class FeaturedImagesController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :edit, :update, :destroy]

  def index
    @featured_images = FeaturedImage.paginate(page: params[:page], :per_page => 25)
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
      s3 = AWS::S3.new(:access_key_id => ENV["S3_KEY_ID"], :secret_access_key => ENV["S3_SECRET"])
      bucket = s3.buckets[S3_CONFIG["fimage_bucket"]]
      @name = @fimage.id.to_s + ".png"
      @png = Base64.decode64(@fimage.data['data:image/png;base64,'.length .. -1])
      obj = bucket.objects.create(@name, @png, {content_type: "image/png", ac1: "public_read"})
    else
      flash[:error] = "Oh noes! Something went wrong!"
    end
    redirect_to root_url
  end

  def show
    @fimage = FeaturedImage.find(params[:id])
    @aide = @fimage.mnemonic_aide.gsub /([^\p{ASCII}—Øüäöß])/, '<a href=/hurl/\1>\1</a>'
    @commentary = @fimage.commentary.gsub /([^\p{ASCII}—Øüäöß])/, '<a href=/hurl/\1>\1</a>'
    @hanzi = Hanzi.find(@fimage.hanzi_id)
    @gbeginning = Gorodish.find_by(element: @fimage.pinyindefinition.gbeginning)
    @gending = Gorodish.find_by(element: @fimage.pinyindefinition.gending)
    @examples = @hanzi.subtitles.limit(7)
    @comments = @hanzi.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "hanzi"
    @topic_id = @hanzi.id
    @stroke_order = check_stroke_order(@hanzi.character)
    @gorodishes_all = []
    @hanzi.pinyindefinitions.each do |pd|
      if pd.gbeginning != ""
        @gorodishes_all.append(Gorodish.find_by(element: pd.gbeginning))
      end
      if pd.gending != ""
        @gorodishes_all.append(Gorodish.find_by(element: pd.gending))
      end
    end
    @gorodishes = @gorodishes_all.uniq
    @appearances = Hanzi.where('components LIKE ?', "%#{@hanzi.character}%")
    @appearances_with_mnemonics = @appearances.joins(:mnemonics)
    @appearances_ids = @appearances.dup.to_a
    @appearances_ids.collect! do |h|
      h.id
    end
    @appearances_fimages = FeaturedImage.where(:hanzi_id => @appearances_ids)
    @dictionary = @appearances_fimages.dup.to_a
    @dictionary.collect! do |d|
      [d.id, d.hanzi_id]
    end
    @previous_featured_image = @fimage.previous
    @first_featured_image = FeaturedImage.first
    @next_featured_image = @fimage.next
    @last_featured_image = FeaturedImage.last
    if @fimage == @last_featured_image or @next_featured_image == @last_featured_image
      @last_featured_image = nil
    end
    if @fimage == @first_featured_image or @previous_featured_image == @first_featured_image
      @first_featured_image = nil
    end
    if @hanzi.simplifieds.any?
      @words = Word.where('traditional LIKE ?', "%#{@hanzi.character}%").paginate(page: params[:page], per_page: 40)
    else
      @words = Word.where('simplified LIKE ?', "%#{@hanzi.character}%").paginate(page: params[:page], per_page: 40)
    end
    store_location
  end

  def edit
    @fimage = FeaturedImage.find(params[:id])
    @hanzi = Hanzi.find(@fimage.hanzi_id)
  end

  def update
    @fimage = FeaturedImage.find(params[:id])
    if @fimage.update_attributes(fimage_params)
      flash[:success] = "Featured Image updated!"
    else
      flash[:error] = "Featured Image unchanged!"
    end
    redirect_to root_url
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
      params.require(:featured_image).permit(:data, :commentary, :mnemonic_aide, :hanzi_id, :pinyindefinition_id)
    end
end
