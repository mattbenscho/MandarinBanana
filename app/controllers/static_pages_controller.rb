class StaticPagesController < ApplicationController
  def home
    @newest_fimage = FeaturedImage.last
    redirect_to @newest_fimage
  end

  def about
  end

end
