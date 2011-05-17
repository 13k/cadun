$:.push File.expand_path('lib', __FILE__)

require 'uri'
require 'cgi'
require 'net/http'
require 'nokogiri'
require 'date'
require 'cadun/gateway'
require 'cadun/user'

module Cadun
  VERSION = "0.0.1"
end
