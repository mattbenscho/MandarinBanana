class ReviewsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:show, :answer, :fail, :fail_action, :validate, :update, :destroy]

  def index 
    @next = current_user.reviews.first
    @review = pick_review(@next)
    if !@review.nil?
      redirect_to @review
    end
  end

  def new
  end

  def create
    @review = current_user.reviews.build(review_params)
    @review.due = Time.now
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
    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)
    @subtitles = @hanzi.subtitles.limit(7)
    @reviewed_today = Review.where("updated_at >= ? AND user_id = ?", Date.today, current_user.id).count
    @due_reviews_count = Review.where("due < ? AND user_id = ?", Time.now + 1.hours, current_user.id).count
    if current_user.reviews.count != 0
        @progress = 100 - (@due_reviews_count).to_f / (@reviewed_today + @due_reviews_count).to_f * 100
    else
        @progress = 100
    end
  end

  def answer
    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)
    @subtitles = @hanzi.subtitles.limit(7)
    @appearances = Hanzi.where('components LIKE ?', "%#{@hanzi.character}%")
    @stroke_order = check_stroke_order(@hanzi.character)
    @comments = @hanzi.comments
  end

  def fail
    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)
    @appearances = Hanzi.where('components LIKE ?', "%#{@hanzi.character}%")
    @reviewed_appearances_counter = 0
    @unknown_appearances = ""
    @appearances.each do |a|
      @is_being_reviewed = Review.find_by(hanzi_id: a.id)
      if @is_being_reviewed.nil?
        @unknown_appearances += a.character
      else
        @reviewed_appearances_counter += 1
      end
    end
  end

  def fail_action
    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)
    if params[:antedate] == 'yes'
      Hanzi.where('components LIKE ?', "%#{@hanzi.character}%").each do |h|
        @child_review = current_user.reviews.where("hanzi_id = ?", h.id).first
        if !@child_review.nil?
          @child_review.due = Time.now
          @child_review.save
        end
      end
    end
    @hanzi.components.each_char do |c|
      if params["#{c}"] == '1'
        @parent_review = current_user.reviews.find_by(hanzi_id: Hanzi.find_by(character: c).id)
        if !@parent_review.nil?
          @parent_review.due = Time.now
          @parent_review.save
        end
      end
    end
    @review.increment(:failed)
    @review.due = Time.now
    @review.save
    @next = pick_review(current_user.reviews.first)
    redirect_to @next
  end

  def validate
    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)
    @rating = params[:rating]
    @factor = case @rating
              when "2" then 1
              when "3" then 2
              when "4" then 4
              end
    @interval = (Time.now - @review.updated_at).to_i() * @factor
    if @interval < 1.day
      @interval = 10.hours
    end
    @interval += (2*rand-1) * 0.1 * @interval
    @review.due = Time.now + @interval
    @review.save
    @next = pick_review(current_user.reviews.first)
    if !@next.nil? and Time.now > @next.due
      redirect_to review_path(@next.id)
    else 
      redirect_to reviews_path
    end
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

    def pick_review(review)
      if current_user.reviews.any?
        @review = review
        @picked_hanzi = Hanzi.find_by(id: @review.hanzi_id)
        @candidate_has_due_component = nil
        Review.where("due < ? AND user_id = ?", Time.now + 1.hours, current_user.id).each do |candidate|
          @candidate_hanzi = Hanzi.find_by(id: candidate.hanzi_id)
          @candidate = candidate
          if !@picked_hanzi.components[@candidate_hanzi.character].nil?        
            @candidate_has_due_component = true
            break
          end
        end 
        if @candidate_has_due_component.nil?
          if !@candidate.nil? and @candidate.due < Time.now + 1.hours
            return @review
          else
            return nil
          end
        else
          pick_review(@candidate)
        end
      else
        return nil
      end
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
