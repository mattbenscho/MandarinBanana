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
        flash[:error] = "Comment not saved, please try again."
        redirect_to subtitle_path(@subtitle)
      end
    elsif params[:comment][:topic] == "hanzi"
      @hanzi = Hanzi.find_by(id: (params[:comment][:hanzi_id]))
      if @comment.save
        flash[:success] = "Comment saved."
        redirect_to hanzi_path(@hanzi)
      else
        @comments = @hanzi.comments
        flash[:error] = "Comment not saved, please try again."
        redirect_to hanzi_path(@hanzi)
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted."
    redirect_back_or comments_url
  end

  private

    def comment_params
      params.require(:comment).permit(:content,:subtitle_id,:hanzi_id)
    end

    def correct_user
      @user = User.find(Comment.find(params[:id]).user_id)
      redirect_to(root_url) unless current_user?(@user)
    end

end
