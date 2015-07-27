class StaticPagesController < ApplicationController
  def home
    redirect_to FeaturedImage.last unless FeaturedImage.last.nil?
  end

  def about
  end

end
