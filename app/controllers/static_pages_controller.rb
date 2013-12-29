class StaticPagesController < ApplicationController
  def home
    @comment = current_user.comments.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
