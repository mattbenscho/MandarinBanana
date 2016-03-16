class SubtitlesController < ApplicationController
  before_action :admin_user, only: [:edit, :update, :destroy]

  def show
    store_location
    @subtitle = Subtitle.find(params[:id])
    @comments = @subtitle.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "subtitle"
    @topic_id = @subtitle.id
    @vocabulary = @subtitle.vocabulary
    @pinyin = @subtitle.pinyin
  end

  def edit
    @subtitle = Subtitle.find(params[:id])
  end

  def update
    if current_user.admin?
      @subtitle = Subtitle.find(params[:id])
      @subtitle.sentence = params[:subtitle][:sentence]
      @subtitle.pinyin = params[:subtitle][:pinyin]
      @subtitle.words = params[:subtitle][:words]
      @subtitle.save!
    end
    redirect_back_or root_url
  end

  private

    def admin_user
      redirect_back_or root_url unless current_user.admin? && !current_user.nil?
    end
end

