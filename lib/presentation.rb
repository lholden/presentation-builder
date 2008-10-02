# = Presentation Builder
#
# Author:: Lori Holden (http://loriholden.com)
# Copyright:: Copyright (c) 2008 Lori Holden
# License:: This code is free to use under the terms of the MIT license.
require 'optparse'
require 'rubygems'
require 'rdiscount'
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
  
  # The builder class ties everything together to build presentations
  class Builder
    attr_reader :config
    
    include Helpers
    
    def initialize
      @config = OpenObject.new
      build_config
    end
    
    # Build presentation
    def build
      display "Rendering to: #{config.destination_file}" do
        open(config.destination_file, 'w') do |out|
          out << process
        end
      end
      display "Finished!"
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
          File.read(File.join(config.template_dir, content))
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
      
      def display(text, options = {})
        @_display_indent ||= 0
        options.reverse_merge!({
          :force => false
        })
        
        puts text.to_s.indent(3 * @_display_indent) unless silent? && !options[:force]
        
        if block_given?
          @_display_indent += 1
          yield
          @_display_indent -= 1
        end
      end
      
      def help(text)
        display text, :force => true
      end
      
      def error(text)
        display text, :force => true
      end
      
      def silent?
        config.silent
      end
      
    private
      def process
        @slides = process_slides
        display "Layout: #{File.join(config.template_dir, config.layout_file)}"
        render(:template, config.layout_file)
      end
      
      def process_slides
        slide_glob = File.join(config.template_dir, config.slide_dir, "*.#{config.slide_extension}")
        Dir.glob(slide_glob).map do |file_name|
          display "Slide: #{file_name}"
          markup(render(:file, file_name))
        end
      end
      
      def build_config
        config.update(YAML.load_file(File.join(PB_PATH, 'config.yaml')))
        
        OptionParser.new do |opts|
          
          opts.separator "Options:"
          opts.on('-t', '--template DIR', 'Location of slide templates') {|v| config.template_dir = v}
          opts.on('-s', '--slide DIR', 'slides location under template_dir') {|v| config.slide_dir = v}
          opts.on('-e', '--example DIR', 'location of source code examples') {|v| config.example_dir = v}
          opts.on('-l', '--layout FILE', 'The layout for the presentation') {|v| config.layout_file = v}
          opts.on('-d', '--destination FILE', 'Where to save the presentation render') {|v| config.destination_file = v}
          opts.on('-x', '--extension EXT', 'Extension expected on each slide template') {|v| config.slide_extension = v}
          opts.on('-g', '--theme NAME', 'Code highlighting theme to use') {|v| config.highlight_theme = v}
          
          opts.on_tail('-h', '--help', 'Shows this help message') do
            help opts
            exit
          end
          opts.on_tail("--version", "Show version") do
            help "#{NAME} - #{VERSION.join('.')}", :force => true
            exit
          end
          opts.define_tail "\nPresentation Builder - A tool for building presentations"
          begin
            opts.parse!
          rescue OptionParser::InvalidOption => e
            help e.message
            help opts
            exit
          end
        end
      end
  end
  
  def self.build(*args)
    (Builder.new).build(*args)
  end
end