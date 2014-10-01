class ReviewsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:show, :answer, :fail, :fail_action, :update, :destroy]

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
    @random = @hanzi.subtitles.count
    if @random > 0
      @subtitle = @hanzi.subtitles.sample
      @file = @subtitle.filename + ".ogv"
    end
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
    counter = 0
    to_fail = []
    if !params[:subtitle_id].nil?
      @subtitle = Subtitle.find(params[:subtitle_id])
      @subtitle.sentence.each_char do |char|
        counter += 1
        @answer = params["selection" + counter.to_s]
        if !@answer.nil?
          @sentence_hanzi = Hanzi.find_by(character: char)
          if !@sentence_hanzi.nil?
            if @answer == @sentence_hanzi.character
              validate(current_user.reviews.find_by(hanzi_id: @sentence_hanzi.id))
            else
              to_fail << current_user.reviews.find_by(hanzi_id: @sentence_hanzi.id).id
            end
          end
        end
      end
    else
      counter += 1
      @answer = params["selection1"]
      @hanzi = Hanzi.find(@review.hanzi_id)
      if @answer == @hanzi.character
        validate(@review)
      else
        to_fail << @review.id
      end        
    end
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)
    if to_fail.length == 0
      flash[:success] = encourage
      @next = pick_review(current_user.reviews.first)
      if !@next.nil? and Time.now > @next.due
        redirect_to review_path(@next.id)
      else 
        redirect_to reviews_path
      end
    else
      redirect_to :action => "fail", :to_fail => to_fail, :id => @review.id
    end
  end

  def fail
    @to_fail = params[:to_fail]
  end

  def fail_action
    params.keys.grep(/to_fail_id/).each do |c|
      @review_to_fail = Review.find(c.gsub('to_fail_id', ''))
      @review_to_fail.increment(:failed)
      @review_to_fail.due = Time.now
      @review_to_fail.save
    end

    params.keys.grep(/char/).each do |c|
      @hanzi_to_fail = Hanzi.find_by(character: c.gsub('char', ''))
      @review = current_user.reviews.find_by(hanzi_id: @hanzi_to_fail.id)
      if !@review.nil?
        @review.due = Time.now
        @review.save
      end
    end

    params.keys.grep(/antedate/).each do |a|
      @parent_review = Review.find(a.gsub('antedate', ''))
      @parent_hanzi = Hanzi.find(@parent_review.hanzi_id)
      Hanzi.where('components LIKE ?', "%#{@parent_hanzi.character}%").each do |h|
        @child_review = current_user.reviews.where("hanzi_id = ?", h.id).first
        if !@child_review.nil?
          @child_review.due = Time.now
          @child_review.save
        end
      end
    end

    @review = current_user.reviews.find_by(id: params[:id])
    @hanzi = Hanzi.find_by(id: @review.hanzi_id)

    @next = pick_review(current_user.reviews.first)
    redirect_to @next
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

    def validate(review)
      @hanzi = Hanzi.find_by(id: review.hanzi_id)
      @factor = 2
      @interval = (Time.now - review.updated_at).to_i() * @factor
      if @interval < 1.day
        @interval = 10.hours
      end
      @interval += (2*rand-1) * 0.1 * @interval
      review.due = Time.now + @interval
      review.save
    end

    def encourage
      return ["That's totally right!", "Yes!", "Correct!", "Right!", "True!"].sample
    end

end
