class StaticPagesController < ApplicationController
  def home
    @hanzis_with_subtitles = Hanzi.joins(:subtitles).uniq
    @hanzis_with_mnemonics = Hanzi.includes(:mnemonics).where.not(:mnemonics => { id: nil })
    @to_be_covered = @hanzis_with_subtitles - @hanzis_with_mnemonics
    @to_be_covered_count = @to_be_covered.count
    @next = @to_be_covered[0..15]
    @mnemonic_total_count = Mnemonic.all.count
    @mnemonic_uniq_count = Hanzi.joins(:mnemonics).uniq.count
    @mnemonic_count_7_days = Hanzi.includes(:mnemonics).where(:mnemonics => { created_at: [7.days.ago..Time.zone.now] }).count
    @mnemonic_count_today = Hanzi.includes(:mnemonics).where(:mnemonics => { created_at: [Time.zone.today.beginning_of_day..Time.zone.now] }).count
    # Last three featured images
    @fimage = FeaturedImage.last
    @previous_featured_image = @fimage.previous unless FeaturedImage.last.nil?
    @previous_previous_featured_image = @previous_featured_image.previous unless @previous_featured_image.nil?
  end

  def about
  end

end
