# Author:: Lori Holden (http://loriholden.com)
# Copyright:: Copyright (c) 2008 Lori Holden
# License:: This code is free to use under the terms of the MIT license.

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
      code_str = Uv.parse(string.tabto(0), 'xhtml', lang, false, config.highlight_theme)
      "\n\n#{code_str}\n\n"
    end
    
    def example(filename, options = {})
      options = { 
        :syntax => nil,
        :start => 1,
        :lines=> nil 
      }.merge!(options)
      
      filename = File.join(config.example_dir, filename)
      unless File.file? filename 
        error "The specified example: #{filename} does not exist."
        exit
      end
      
      if options[:syntax].nil?
        candidates = Uv.syntax_for_file filename
        if candidates.size > 1
          msg = "Many syntaxes match, please specify\n"
          msg << "Matching syntaxes:"
          candidates.sort.each { |name, syntax| msg << "\t - " + name}
          error msg
          exit
        elsif candidates.size < 1
          error "No default syntax found, please specify"
          exit
        end
        
        options[:syntax] = candidates.first.first
      end
      
      file_lines = File.readlines(filename)
      options[:lines] ||= file_lines.size
      
      file_data = file_lines[options[:start] -1, options[:lines]].join
      code(options[:syntax], file_data)
    end
  end
end