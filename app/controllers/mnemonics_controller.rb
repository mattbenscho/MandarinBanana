class MnemonicsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @mnemonic = Mnemonic.new
    @parent = params[:parent]
    @id = params[:id]
  end
  
  def create
    @mnemonic = current_user.mnemonics.build(mnemonic_params)
    if @mnemonic.save
      flash[:success] = "Mnemonic saved."
      redirect_to @mnemonic
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

  private

    def mnemonic_params
      params.require(:mnemonic).permit(:aide, :gorodish_id, :pinyindefinition_id)
    end


end
