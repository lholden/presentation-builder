require 'rubygems'
require 'rdiscount'
require 'erubis'
require 'uv'

PB_PATH = File.dirname(File.dirname(__FILE__))

require File.join(PB_PATH, 'config')
require File.join(PB_PATH, 'lib', 'helpers')
require File.join(PB_PATH, 'lib', 'exceptions')

# Depends on:
#   rdiscount, erubis, ultraviolet
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
      # :template -- relative to the templates dir
      # :file     -- outside the templates dir
      # :inline   -- string
      def render(type = :template, content = '')
        if content.nil? or content.empty?
          raise RenderException.new "No content specified"
        end
        
        raw = case type
        when :file
          File.read(content)
        when :template
          File.read(File.join(Config.template_dir, content))
        when :inline
          content
        else
          raise RenderException.new "Unknown render type: #{type}"
        end
        erubis(raw)
      end
      
      def markup(data)
        RDiscount.new(data).to_html
      end
      
      def erubis(data)
        Erubis::Eruby.new(data).result(binding())
      end
      
    private
      def process
        @slides = process_slides
        render(:template, Config.layout_file)
      end
      
      def process_slides
        slide_glob = File.join(Config.template_dir, Config.slide_dir, "*.#{Config.slide_extension}")
        Dir.glob(slide_glob).map do |file_name|
          markup(render(:file, file_name))
        end
      end
  end
end