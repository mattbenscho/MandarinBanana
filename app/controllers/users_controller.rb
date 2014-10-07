class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    if @user.reviews.any?
      @user_reviews_count = @user.reviews.count
      @due_reviews_count = Review.where("due < ? AND user_id = ?", Time.now + 1.hours, @user.id).count
      @added_first = Review.where(user_id: @user.id).sort_by(&:created_at).first.created_at
      # @average = "%.2g" % @user_reviews_count / (Time.now - @added_first)
      @average = "%.2g" % (@user_reviews_count/((Time.now - @added_first)/(3600*24)))
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Mandarin Banana!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin? && !current_user.nil?
    end
end
