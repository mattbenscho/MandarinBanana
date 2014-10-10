module FeaturedImagesHelper
  def previous_fimage_for(featured_image)
    @featured_images = FeaturedImage.all
    @previous_featured_image = @featured_images[@featured_images.index(featured_image) - 1]
    if !@previous_featured_image == @featured_images.last
      link_to "<- previous featured image", @previous_featured_image
    end
  end

  def next_fimage_for(featured_image)
    @featured_images = FeaturedImage.all
    @next_featured_image = @featured_images[@featured_images.index(featured_image) + 1]
    if !@next_featured_image == nil
      link_to "next featured image ->", @next_featured_image
    end
  end

end
