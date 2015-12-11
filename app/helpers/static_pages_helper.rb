module StaticPagesHelper
  def display_next(collection)
    render :partial => "next_hanzi", collection: collection
  end

  def fimage_preview(fimage)
    render :partial => "fimage_preview", locals: {fimage: fimage}
  end
end
