# = Presentation Builder
#
# Author:: Lori Holden (http://loriholden.com)
# Copyright:: Copyright (c) 2008 Lori Holden
# License:: This code is free to use under the terms of the MIT license.
require 'rubygems'
require 'optparse'
require 'rdiscount'
require 'ostruct'
require 'erubis'
require 'uv'
require 'facets'
require 'facets/openobject'

PB_PATH = File.dirname(__DIR__)

require File.join(PB_PATH, 'lib', 'helpers')
require File.join(PB_PATH, 'lib', 'exceptions')

module Presentation
  VERSION = [0, 5, 0]
  NAME = "Presentation Builder"
  
  Config = OpenObject.new
  
  # The builder class ties everything together to build presentations
  class Builder
    include Helpers
    
    def initialize
      build_config
    end
    
    # Build presentation
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
        raise ArgumentError.new "No content specified" if content.blank?
        
        raw = case type
        when :file
          File.read(content)
        when :template
          File.read(File.join(Config.template_dir, content))
        when :inline
          content
        else
          raise ArgumentError.new "Unknown render type: #{type}"
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
      
      def build_config
        Config.update(YAML.load_file(File.join(PB_PATH, 'config.yaml')))
        
        OptionParser.new do |opts|
          
          opts.separator "Options:"
          opts.on('-t', '--template DIR', 'Location of slide templates') {|v| Config.template_dir = v}
          opts.on('-s', '--slide DIR', 'slides location under template_dir') {|v| Config.slide_dir = v}
          opts.on('-e', '--example DIR', 'location of source code examples') {|v| Config.example_dir = v}
          opts.on('-l', '--layout FILE', 'The layout for the presentation') {|v| Config.layout_file = v}
          opts.on('-d', '--destination FILE', 'Where to save the presentation render') {|v| Config.destination_file = v}
          opts.on('-x', '--extension EXT', 'Extension expected on each slide template') {|v| Config.slide_extension = v}
          opts.on('-g', '--theme NAME', 'Code highlighting theme to use') {|v| Config.highlight_theme = v}
          
          opts.on_tail('-h', '--help', 'Shows this help message') do
            puts opts
            exit
          end
          opts.on_tail("--version", "Show version") do
            puts "#{NAME} - #{VERSION.join('.')}"
            exit
          end
          opts.define_tail "\nPresentation Builder - A tool for building presentations"
          begin
            opts.parse!
          rescue OptionParser::InvalidOption => e
            puts e.message
            puts opts
            exit
          end
        end
      end
  end
  
  def self.build(*args)
    (Builder.new).build(*args)
  end
end