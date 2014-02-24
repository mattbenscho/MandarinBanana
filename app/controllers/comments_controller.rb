class CommentsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @comments = Comment.paginate(page: params[:page])
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if params[:comment][:topic] == "subtitle"
      @subtitle = Subtitle.find_by(id: (params[:comment][:subtitle_id]))
      if @comment.save
        flash[:success] = "Comment saved."
        redirect_to subtitle_path(@subtitle)
      else
        @comments = @subtitle.comments
        render 'subtitles/show'
      end
    elsif params[:comment][:topic] == "hanzi"
      @hanzi = Hanzi.find_by(id: (params[:comment][:hanzi_id]))
      if @comment.save
        flash[:success] = "Comment saved."
        redirect_to hanzi_path(@hanzi)
      else
        @comments = @hanzi.comments
        render 'hanzi/show'
      end
    end
  end

  def destroy
  end

  private

    def comment_params
      params.require(:comment).permit(:content,:subtitle_id,:hanzi_id)
    end
end
