class StaticPagesController < ApplicationController
  def home
    @next = (Hanzi.joins(:subtitles).uniq - Hanzi.includes(:mnemonics).where.not(:mnemonics => { id: nil }))[0..15]
  end

  def about
  end

end
