class StaticPagesController < ApplicationController
  def home
    @comment = current_user.comments.build if signed_in?
  end

  def about
  end

end
