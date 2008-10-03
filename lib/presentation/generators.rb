module Presentation
  module Generators
    GENERATOR_TEMPLATE_DIR = File.join(__DIR__, 'generator_templates')
    extend Templater::Manifold
    desc <<-DESC
      Generate components for your presentation or entirely new presentations.
    DESC
    
    class PresentationGenerator < Templater::Generator
      # Template directory for the generator
      def self.source_root
        File.join(GENERATOR_TEMPLATE_DIR, 'presentation')
      end
      
      desc <<-DESC
        Generates a new presentation
      DESC
      
      first_argument :name, :required => true, :desc => "Presentation name"
      
      file :config_yaml, 'config.yaml'
      file :title_slide, File.join('templates', 'slides', '001_title.markdown.erb')
      empty_directory :examples, 'examples'
      empty_directory :templates_slides, File.join('templates', 'slides')
      glob! 'public'
      
      invoke :layout do |g|
        g.new(destination_root, options, 'index')
      end
      
      def destination_root
        File.join(@destination_root, name.snake_case)
      end
      
    end
    
    class LayoutGenerator < Templater::Generator
      def self.source_root
        GENERATOR_TEMPLATE_DIR
      end
      
      desc <<-DESC
        Generates a layout
      DESC
      
      first_argument :name, :required => true, :desc => 'layout name'
      
      template :layout do |t|
        t.source = 'layout.html.erb'
        t.destination = "templates/#{name.snake_case}.html.erb"
      end
    end
    
    class SlideGenerator < Templater::Generator
      def self.source_root
        GENERATOR_TEMPLATE_DIR
      end
      
      desc <<-DESC
        Generates a slide
      DESC
      
      first_argument :name, :required => true, :desc => 'slide name'
      
      template :slide do |t|
        t.source = 'slide.markdown.erb'
        t.destination = File.join(destination_directory, "#{version}_#{name.snake_case}.markdown.erb")
      end
      
      def version
        format("%03d", current_slide_number + 1)
      end
      
      protected
        def destination_directory
          File.join(destination_root, 'templates', 'slides')
        end
        
        def current_slide_number
          Dir["#{destination_directory}/*"].map{|f| File.basename(f).match(/^(\d+)/)[0].to_i  }.max.to_i
        end
    end
    
    add :presentation, PresentationGenerator
    add :layout, LayoutGenerator
    add :slide, SlideGenerator
  end
end