$:.push File.expand_path('lib', __FILE__)

require 'uri'
require 'cgi'
require 'net/http'
require 'nokogiri'
require 'date'
require 'yaml'
require 'singleton'
require 'active_support/core_ext/hash'
require 'globocom-auth/gateway'
require 'globocom-auth/user'
require 'globocom-auth/config'
