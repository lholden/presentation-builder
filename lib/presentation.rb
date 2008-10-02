require 'optparse'
require 'rubygems'
require 'rdiscount'
require 'erubis'
require 'uv'
require 'facets'
require 'facets/openobject'

PB_PATH = File.dirname(__DIR__)

module Presentation
  VERSION = [0, 5, 0]
  NAME = "Presentation Builder"
  INDENT = 3
end

require File.join(PB_PATH, 'lib', 'presentation', 'helpers')
require File.join(PB_PATH, 'lib', 'presentation', 'exceptions')
require File.join(PB_PATH, 'lib', 'presentation', 'builder')



