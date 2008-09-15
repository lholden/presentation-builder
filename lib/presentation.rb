require 'rubygems'
require 'rdiscount'
require 'erubis'
require 'ostruct'
require 'uv'

module Presentation
  Presentation::Config = OpenStruct.new(
    :layout_file => File.join('src', 'index.html.eruby'),
    :slide_dir => File.join('src', 'slides'),
    :markup => 'markdown',
    :erubis_extension => 'eruby'
  )
  
  def self.build
    (Builder.new).build
  end
  module Helpers
    def h(string)
      # not really a sanatizer, but don't want to break <pre> tags if html is
      # used for the code helper.
      string.gsub(/[<]/, '&lt;').gsub(/[>]/, '&gt;')
    end
    
    def handout(string)
      %Q{<div class="handout">#{string}</div>}
    end
    
    def code(lang, string)
      code_str = Uv.parse( string.strip, 'xhtml', lang, false, "twilight")
      "\n\n#{code_str}\n\n"
    end
  end
  class Builder
    include Helpers
    
    def build
      open('index.html', 'w') do |out|
        out << process
      end
    end
  
    protected
      def process
        @slides = slide_data.map { |s| render_slide s }
        erubis(layout_data)
      end
    
      def render_slide(slide)
        RDiscount.new(erubis(slide)).to_html
      end
    
      def erubis(data)
        Erubis::Eruby.new(data).result(binding())
      end

      def layout_data
        File.read(Config.layout_file)
      end
      def slide_data
        slide_glob = File.join(Config.slide_dir, "*.#{Config.markup}.#{Config.erubis_extension}")
        Dir.glob(slide_glob).map {|f| File.read(f) }
      end
  end
end