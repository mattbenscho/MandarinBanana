module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Mandarin Banana"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def recursive_wallposts(parent)
    html = ''
    Wallpost.where(parent_id: parent).each do |child|
      @user = User.find(child.user_id)
      html << '<div class="wallpost-container">'
      html << '<span class="timestamp">'
      html << @user.name
      html << ' posted '
      html << time_ago_in_words(child.created_at)
      html << ' ago: </span><span class="content">'
      html << child.content
      html << '</span> <span><a href="wallposts/'
      html << child.id.to_s
      html << '/new">// Reply</a></span></br>'
      html << recursive_wallposts(child.id)
      html << '</div>'
    end
    return html
  end

end
