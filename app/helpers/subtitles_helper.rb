# -*- coding: utf-8 -*-
module SubtitlesHelper

  # Return id of previous subtitle
  def previous_for(subtitle)
    @subtitles = Subtitle.where(movie_id: @subtitle.movie_id)
    @previous_subtitle = @subtitles[@subtitles.index(@subtitle) - 1]
    if @previous_subtitle == @subtitles.last
      link_to "Home", '/'
    else
      link_to "<<", @previous_subtitle
    end
  end

  # Return id of next subtitle
  def next_for(subtitle)
    @subtitles = Subtitle.where(movie_id: @subtitle.movie_id)
    @next_subtitle = @subtitles[@subtitles.index(@subtitle) + 1]
    if @next_subtitle == nil
      link_to "Home", '/'
    else
      link_to ">>", @next_subtitle
    end
  end

end
