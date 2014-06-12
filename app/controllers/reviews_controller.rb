class ReviewsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:destroy]

  def index
  end

  def new
  end

  def create
    @review = current_user.reviews.build(review_params)
    @review.due = DateTime.current
    @review.failed = 0
    if @review.save
      flash[:success] = "Review created!"
      redirect_to hanzi_url(Hanzi.find_by(id: @review.hanzi_id))
    else
      flash[:error] = "An error has occured!"
      redirect_to root_url
    end
  end

  def show
  end

  def update
  end

  def destroy
    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find(@review.hanzi_id)
    if @review.destroy
      flash[:success] = "Stopped reviewing!"
    end
    redirect_to hanzi_url(@hanzi)
  end

  private

    def review_params
      params.require(:review).permit(:hanzi_id)
    end

    # Before filters

    def correct_user
      @review = current_user.reviews.find_by(id: params[:id])
      redirect_to root_url if @review.nil?
    end

end
