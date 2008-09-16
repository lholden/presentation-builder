require 'ostruct'

module Presentation
  Config = OpenStruct.new(
    :layout_file => File.join('src', 'index.html.eruby'),
    :slide_dir => File.join('src', 'slides'),
    :example_dir => 'examples',
    :destination_file => File.join('public', 'index.html'),
    :markup => 'markdown', # configs filename. my_file.markdown.eruby for example
    :erubis_extension => 'eruby',
    :highlight_theme => 'sunburst'
  )
end