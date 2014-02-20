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

  def recursive_decompose(composition)
    html=''
    if composition.length > 0
      composition.each_char do |char|
        @char = Hanzi.find_by(character: char)
        if @char
          html << '<div class="row-fluid"><div class="span1 pagination-centered"><b><a href="/hanzis/' + @char.id.to_s + '">' + char + '</a></b></div><div class="span11"><div class="row-fluid">'
          @char.pinyindefinitions.each do |pinyindefinition|
            html << '<div class="span2 pagination-centered"><b>' + pinyindefinition.pinyin + " / " + pinyindefinition.gbeginning + pinyindefinition.gending + '</b></div><div class="span10">' + pinyindefinition.definition + ' - <a href="/pinyindefinitions/' + pinyindefinition.id.to_s + '/mnemonics/new">add mnemonic</a>' + '<br/><br/>'
            pinyindefinition.mnemonics.each do |mnemonic|
              html << mnemonic.aide + ' - <a href="/mnemonics/' + mnemonic.id.to_s + '/images/new">add image</a>' + '<br/>'
              mnemonic.images.each do |image|
                html << '<img width=100 src="' + image.data + '">'
              end
            end              
            html << '</div></div></div></div>'
          end
          @children = @char.components
          if @children.length > 0
            html << recursive_decompose(@children)
          end
        else
          html << '<div class="row-fluid"><div class="span1 pagination-centered"><b>' + char + '</b></div><div class="span11"></div></div>'
        end
      end
    end
    return html
  end
  
  def decompose(composition)
    recursive_decompose(composition).html_safe
  end
end
