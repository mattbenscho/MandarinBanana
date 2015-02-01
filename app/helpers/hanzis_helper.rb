module HanzisHelper
  def check_for_fimages dictionary, hanzi_id
    @fimage_ids = dictionary.transpose[0]
    @fimage_hanzi_ids = dictionary.transpose[1]
    if @fimage_hanzi_ids.nil?
      @fimage_hanzi_ids_indices = []
    else
      @fimage_hanzi_ids_indices = @fimage_hanzi_ids.size.times.select { |i| @fimage_hanzi_ids[i] == hanzi_id }
    end
    @ids = []
    @fimage_hanzi_ids_indices.each do |i|
      @ids.push(@fimage_ids[i])
    end
    return @ids
  end
end
