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
require 'templater'

PB_PATH = File.dirname(__DIR__)
PB_LIBS = File.join(PB_PATH, 'lib', 'presentation')

%w{version helpers builder generators}.each do |file|
  require File.join(PB_LIBS, file)
end

module Presentation
  class RenderException < Exception #:nodoc:
  end
end