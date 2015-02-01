class GorodishesController < ApplicationController
  def show
    @gorodish = Gorodish.find(params[:id])
    @appearances = Hanzi.includes(:pinyindefinitions).where('pinyindefinitions.gbeginning = ? OR pinyindefinitions.gending = ?', @gorodish.element, @gorodish.element).references(:pinyindefinitions)
    @appearances_ids = @appearances.dup.to_a
    @appearances_ids.collect! do |h|
      h.id
    end
    @appearances_fimages = FeaturedImage.where(:hanzi_id => @appearances_ids)
    @dictionary = @appearances_fimages.dup.to_a
    @dictionary.collect! do |d|
      [d.id, d.hanzi_id]
    end
    store_location
  end

  def index
    @all_gorodishes = Gorodish.all
    store_location
  end
end
