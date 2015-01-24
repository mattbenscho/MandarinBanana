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
    if @image.save and @image.data != ""
      flash[:success] = "Image saved!"
      s3 = AWS::S3.new(:access_key_id => S3_CONFIG["access_key_id"], :secret_access_key => S3_CONFIG["secret_access_key"])
      bucket = s3.buckets[S3_CONFIG["image_bucket"]]
      @name = @image.id.to_s + ".png"
      @png = Base64.decode64(@image.data['data:image/png;base64,'.length .. -1])
      obj = bucket.objects.create(@name, @png, {content_type: "image/png", ac1: "public_read"})
    else
      flash[:error] = "Uh oh! Image was not saved."      
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
