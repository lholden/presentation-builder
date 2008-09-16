require 'ostruct'

module Presentation
  Config = OpenStruct.new(
    :layout_file => File.join('src', 'index.html.eruby'),
    :slide_dir => File.join('src', 'slides'),
    :destination_file => 'index.html',
    :markup => 'markdown', # configs filename. my_file.markdown.eruby for example
    :erubis_extension => 'eruby'
  )
end