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
  
  def update
  end

  def index
    @mnemonics = Mnemonic.paginate(page: params[:page])
  end

  private

    def mnemonic_params
      params.require(:mnemonic).permit(:aide, :gorodish_id, :pinyindefinition_id)
    end

end
