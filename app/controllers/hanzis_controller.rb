class HanzisController < ApplicationController
  before_action :admin_user, only: [:edit, :update]

  def index
    @hanzis = Hanzi.paginate(page: params[:page], :per_page => 500)
  end

  def search
    @hanzi = Hanzi.find_by(character: "#{params[:character]}")
    if @hanzi.nil? then
      flash[:error] = "I didn't find anything for \"" + "#{params[:character]}" + "\"."
      redirect_back_or root_url
    else
      redirect_to hanzi_url(@hanzi.id)
    end    
  end

  def hurl
    @hanzi = Hanzi.find_by(character: params[:input])
    if @hanzi.nil?
      redirect_to root_url
    else
      redirect_to @hanzi
    end
  end

  def show
    @hanzi = Hanzi.find(params[:id])
    @examples = @hanzi.subtitles.limit(7)
    @comments = @hanzi.comments
    @comment = current_user.comments.build if signed_in?
    @topic = "hanzi"
    @topic_id = @hanzi.id
    @stroke_order = check_stroke_order(@hanzi.character)
    @gorodishes_all = []
    @hanzi.pinyindefinitions.each do |pd|
      if pd.gbeginning != ""
        @gorodishes_all.append(Gorodish.find_by(element: pd.gbeginning))
      end
      if pd.gending != ""
        @gorodishes_all.append(Gorodish.find_by(element: pd.gending))
      end
    end
    @gorodishes = @gorodishes_all.uniq
    @appearances = Hanzi.where('components LIKE ?', "%#{@hanzi.character}%")
    store_location
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

    def check_stroke_order(character)      
      if Rails.application.assets.find_asset 'stroke-order-imgs/' + character + '-order.gif'
        return 'stroke-order-imgs/' + character + '-order.gif'
      elsif Rails.application.assets.find_asset 'stroke-order-imgs/' + character + '-red.png'
        return 'stroke-order-imgs/' + character + '-red.png'
      elsif Rails.application.assets.find_asset 'stroke-order-imgs/' + character + '-bw.png'
        return 'stroke-order-imgs/' + character + '-bw.png'
      else
        return nil
      end
    end
end
