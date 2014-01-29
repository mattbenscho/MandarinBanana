module HanzisHelper
  def recursive_decompose(composition)
    html=''
    if composition.length > 0
      composition.each_char do |char|
        @char = Hanzi.find_by(character: char)
        html << '<b>' + char + '</b> '
        if @char
          @char.pinyindefinitions.each do |pinyindefinition|
            html << '<b>' + pinyindefinition.pinyin + " / " + pinyindefinition.gbeginning + pinyindefinition.gending + "</b>: " + pinyindefinition.definition + ' - <a href="/pinyindefinitions/' + pinyindefinition.id.to_s + '/mnemonics/new">add mnemonic</a>' + '<br/>'
            pinyindefinition.mnemonics.each do |mnemonic|
              html << mnemonic.aide + ' - <a href="/mnemonics/' + mnemonic.id.to_s + '/images/new">add image</a>' + '<br/>'
              mnemonic.images.each do |image|
                html << '<img width=100 src="' + image.data + '"></img>'
              end
              html << '<br/>'
            end              
          end
          @children = @char.components
          if @children.length > 0
            html << recursive_decompose(@children)
          end
        end
      end
    end
    return html
  end
  
  def decompose(composition)
    recursive_decompose(composition).html_safe
  end
end
