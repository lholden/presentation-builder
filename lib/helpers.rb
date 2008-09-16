module Presentation
  module Helpers
    # not the best sanatizer
    def h(string)
      string.gsub(/[<]/, '&lt;').gsub(/[>]/, '&gt;')
    end
    
    def handout(string)
      %Q{<div class="handout">#{string}</div>}
    end
    
    def code(lang, string)
      code_str = Uv.parse( string.strip, 'xhtml', lang, false, "sunburst")
      "\n\n#{code_str}\n\n"
    end
  end
end