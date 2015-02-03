class MnemonicsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @mnemonic = Mnemonic.new
    @parent = params[:parent]
    @id = params[:id]
    if @parent == "pinyindefinitions"
      @pinyindefinition = Pinyindefinition.find_by(id: @id)
      @hanzi = Hanzi.find_by(id: @pinyindefinition.hanzi_id)
      @gbeginning = @pinyindefinition.gbeginning
      @gbeginning_obj = Gorodish.find_by(element: @gbeginning)
      @gending = @pinyindefinition.gending
      @gending_obj = Gorodish.find_by(element: @gending)
      @appearances = Hanzi.where('components LIKE ?', "%#{@hanzi.character}%")
      @appearances_ids = @appearances.dup.to_a
      @appearances_ids.collect! do |h|
        h.id
      end
      @appearances_fimages = FeaturedImage.where(:hanzi_id => @appearances_ids)
      @dictionary = @appearances_fimages.dup.to_a
      @dictionary.collect! do |d|
        [d.id, d.hanzi_id]
      end
    end
    if @parent == "gorodishes"
      @ancestor = Gorodish.find_by(id: @id).element
    end
  end
  
  def create
    @mnemonic = current_user.mnemonics.build(mnemonic_params)
    if @mnemonic.save
      flash[:success] = "Mnemonic saved."
      if !@mnemonic.pinyindefinition_id.nil?
        @pinyindefinition = Pinyindefinition.find_by(id: @mnemonic.pinyindefinition_id)
        @hanzi = Hanzi.find_by(id: @pinyindefinition.hanzi_id)
        redirect_to @hanzi
      elsif !@mnemonic.gorodish_id.nil?
        @gorodish = Gorodish.find_by(id: @mnemonic.gorodish_id)
        redirect_to @gorodish
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def show 
    @mnemonic = Mnemonic.find(params[:id])
    @images = @mnemonic.images
  end
  
  def edit
    @mnemonic = Mnemonic.find(params[:id])
    if !@mnemonic.pinyindefinition.nil?
      @parent = "pinyindefinitions"
      @id = @mnemonic.pinyindefinition.id
      @ancestor = @mnemonic.pinyindefinition
      @pinyindefinition = @mnemonic.pinyindefinition
      @hanzi = @pinyindefinition.hanzi
      @gbeginning = @pinyindefinition.gbeginning
      @gbeginning_obj = Gorodish.find_by(element: @gbeginning)
      @gending = @pinyindefinition.gending
      @gending_obj = Gorodish.find_by(element: @gending)
      @appearances = Hanzi.where('components LIKE ?', "%#{@hanzi.character}%")
      @appearances_ids = @appearances.dup.to_a
      @appearances_ids.collect! do |h|
        h.id
      end
      @appearances_fimages = FeaturedImage.where(:hanzi_id => @appearances_ids)
      @dictionary = @appearances_fimages.dup.to_a
      @dictionary.collect! do |d|
        [d.id, d.hanzi_id]
      end
    end
    if !@mnemonic.gorodish.nil?
      @parent = "gorodishes"
      @id = @mnemonic.gorodish.id
      @gorodish = @mnemonic.gorodish
    end
  end

  def update
    @mnemonic = Mnemonic.find(params[:id])
    if @mnemonic.update_attributes(mnemonic_params)
      flash[:success] = "Mnemonic updated."
      if !@mnemonic.pinyindefinition_id.nil?
        @pinyindefinition = Pinyindefinition.find_by(id: @mnemonic.pinyindefinition_id)
        @hanzi = Hanzi.find_by(id: @pinyindefinition.hanzi_id)
        redirect_to @hanzi
      elsif !@mnemonic.gorodish_id.nil?
        @gorodish = Gorodish.find_by(id: @mnemonic.gorodish_id)
        redirect_to @gorodish
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def destroy
    @mnemonic = Mnemonic.find(params[:id])
    @mnemonic.destroy
    flash[:success] = "Mnemonic deleted."
    redirect_back_or mnemonics_url
  end

  def index
    @mnemonics = Mnemonic.paginate(page: params[:page]).order("created_at DESC")
  end

  private

    def correct_user
      @user = User.find(Mnemonic.find(params[:id]).user_id)
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end

    def mnemonic_params
      params.require(:mnemonic).permit(:aide, :gorodish_id, :pinyindefinition_id)
    end

end
