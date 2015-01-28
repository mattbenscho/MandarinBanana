class StaticPagesController < ApplicationController
  def home
    redirect_to FeaturedImage.last
  end

  def about
  end

end
