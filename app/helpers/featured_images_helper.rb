# -*- coding: utf-8 -*-
module FeaturedImagesHelper
  def first_fimage_for(featured_image)
    @featured_images = FeaturedImage.all
    @previous_featured_image = @featured_images[@featured_images.index(featured_image) - 1]
    if @previous_featured_image != @featured_images.last
      link_to "«", FeaturedImage.first
    end
  end  

  def previous_fimage_for(featured_image)
    @featured_images = FeaturedImage.all
    @previous_featured_image = @featured_images[@featured_images.index(featured_image) - 1]
    if @previous_featured_image != @featured_images.last
      link_to "‹", @previous_featured_image
    end
  end

  def next_fimage_for(featured_image)
    @featured_images = FeaturedImage.all
    @next_featured_image = @featured_images[@featured_images.index(featured_image) + 1]
    if @next_featured_image != nil
      link_to "›", @next_featured_image
    end
  end

  def last_fimage_for(featured_image)
    @featured_images = FeaturedImage.all
    @next_featured_image = @featured_images[@featured_images.index(featured_image) + 1]
    if @next_featured_image != nil
      link_to "»", FeaturedImage.last
    end
  end

end
