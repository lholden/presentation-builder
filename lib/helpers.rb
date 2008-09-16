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
      code_str = Uv.parse(string, 'xhtml', lang, false, Config.highlight_theme)
      "\n\n#{code_str}\n\n"
    end
    
    def example(filename, options = {})
      options = { 
        :syntax => nil,
        :start => 1,
        :lines=> nil 
      }.merge!(options)
      
      filename = File.join(PB_PATH, Config.example_dir, filename)
      unless File.file? filename 
        return "The specified example: #{filename} does not exist."
      end
      
      if options[:syntax].nil?
        candidates = Uv.syntax_for_file filename
        if candidates.size > 1
          error = "Many syntaxes match, please specify\n"
          error << "Matching syntaxes:"
          candidates.sort.each { |name, syntax| error << "\t - " + name}
          return error
        elsif candidates.size < 1
          return "No default syntax found, please specify"
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