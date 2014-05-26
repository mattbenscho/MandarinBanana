class HanzisController < ApplicationController
  before_action :admin_user, only: [:edit, :update]

  def index
    if params[:hanzi_search]
      @hanzi = Hanzi.find_by(character: "#{params[:hanzi_search]}")
      if @hanzi.nil? then
        @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
      else
        redirect_to hanzi_url(@hanzi.id)
      end
    else
      @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
    end
  end

  def show
    @hanzi = Hanzi.find(params[:id])
    @examples = @hanzi.subtitles
    @comments = @hanzi.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "hanzi"
    @topic_id = @hanzi.id
  end

  def edit
    @hanzi = Hanzi.find(params[:id])
  end

  def update
    @hanzi = Hanzi.find(params[:id])
    if @hanzi.update_attributes(hanzi_params)
      flash[:success] = "Hanzi updated"
      redirect_to @hanzi
    else
      render 'edit'
    end
  end

  private

    def hanzi_params
      params.require(:hanzi).permit(:components)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
