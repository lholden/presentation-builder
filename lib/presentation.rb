require 'rubygems'
require 'rdiscount'
require 'erubis'
require 'uv'

PB_PATH = File.dirname(File.dirname(__FILE__))

require File.join(PB_PATH, 'config')
require File.join(PB_PATH, 'lib', 'helpers')

module Presentation
  def self.build(*args)
    (Builder.new).build(*args)
  end
  
  class Builder
    include Helpers
    
    def build
      open(Config.destination_file, 'w') do |out|
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