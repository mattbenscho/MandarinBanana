module WallpostsHelper
  def recursive_wallposts(parent)
    html = ''
    html << '<div class="wallpost-container">'
    Wallpost.where(parent_id: parent).each do |child|
      @user = User.find(child.user_id)
      html << '<p>'
      html << '<span class="timestamp">'
      html << @user.name
      html << ' posted '
      html << time_ago_in_words(child.created_at)
      html << ' ago: </span><span class="content">'
      html << child.content
      html << '</span> <span><a href="wallposts/'
      html << child.id.to_s
      html << '/new"> //&nbsp;Reply</a></span>'
      html << '</p>'
      html << recursive_wallposts(child.id)
    end
    html << '</div>'
    return html
  end
end
