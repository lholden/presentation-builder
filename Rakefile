# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'lib/presentation'

AUTHOR = 'Lori Holden'
EMAIL = 'email+gem@loriholden.com'
DESCRIPTION = 'A presentation building tool'
GEM_NAME = 'pbuilder'
HOMEPATH = 'http://github.com/lholden/presentation-builder'
EXTRA_DEPENDENCIES = [
  ['rdiscount', '>= 1.2'],
  ['erubis', '>= 2.6'],
  ['ultraviolet', '>= 0.10.2'],
  ['facets', '>= 2.4'],
  ['templater', '>= 0.3']
]

Hoe.new(GEM_NAME, Presentation::VERSION::STRING) do |p|
  p.developer(AUTHOR, EMAIL)
  p.description = DESCRIPTION
 	p.summary = DESCRIPTION
 	p.url = HOMEPATH
 	p.clean_globs |= ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']
 	p.extra_deps = EXTRA_DEPENDENCIES
end

# vim: syntax=Ruby
