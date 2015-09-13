class StaticPagesController < ApplicationController
  def home
    @next = (Hanzi.joins(:subtitles).uniq - Hanzi.includes(:mnemonics).where.not(:mnemonics => { id: nil }))[0..15]
    @mnemonic_count_7_days = Mnemonic.where("created_at >= ?", 7.days.ago).count
    @mnemonic_count_today = Mnemonic.where("created_at >= ?", Time.zone.now.beginning_of_day).count
  end

  def about
  end

end
