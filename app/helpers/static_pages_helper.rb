module StaticPagesHelper
  def display_next(collection)
    render :partial => "next_hanzi", collection: collection
  end
end
