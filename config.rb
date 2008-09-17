require 'ostruct'

module Presentation
  Config = OpenStruct.new(
    :template_dir => 'templates',
    :layout_file => 'index.html.eruby',
    :slide_dir => 'slides', # path under template_dir
    :example_dir => 'examples',
    :destination_file => File.join('public', 'index.html'),
    :slide_extension => 'markdown.eruby',
    :highlight_theme => 'sunburst'
  )
end