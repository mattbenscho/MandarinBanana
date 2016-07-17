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
    @vocabulary = @subtitle.vocabulary
    if @subtitle.words.nil?
      @words_string = ""
    else
      @words_string = @subtitle.words.join("|")
    end
    @pinyin_array = Array.new
    if @subtitle.pinyin.nil?
      @pinyin_string = ""
    else
      @subtitle.pinyin.each do |p|
        @pinyin_array.push(p.join("/"))
      end
      @pinyin_string = @pinyin_array.join("|")
    end
  end

  def update
    if current_user.admin?
      @subtitle = Subtitle.find(params[:id])
      if !params[:subtitle][:sentence].nil?
        @subtitle.sentence = params[:subtitle][:sentence]
      end
      @subtitle.chinglish = params[:subtitle][:chinglish]
      @subtitle.english = params[:subtitle][:english]
      if !params[:subtitle][:pinyin].nil?
        @pinyin_string = params[:subtitle][:pinyin]
        @pinyin_array = @pinyin_string.split("|")
        @pinyin = Array.new
        @pinyin_array.each do |p|
          @pinyin.push(p.split("/"))
        end
        @subtitle.pinyin = @pinyin
      end
      if !params[:subtitle][:words].nil?
        @subtitle.words = params[:subtitle][:words].split("|")
      end
      @subtitle.save!
    end
    redirect_back_or root_url
  end

  private

    def admin_user
      redirect_back_or root_url unless current_user.admin? && !current_user.nil?
    end
end

