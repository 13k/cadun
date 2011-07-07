# -*- encoding: utf-8 -*-
require "#{File.dirname(__FILE__)}/lib/cadun/version"

Gem::Specification.new do |s|
  s.name              = 'cadun'
  s.version           = Cadun::VERSION::STRING
  s.platform          = Gem::Platform::RUBY
  s.authors           = %w(Bruno Azisaka Maciel)
  s.email             = %w(bruno@azisaka.com.br)
  s.homepage          = ''
  s.summary           = "A wrapper for the Globo.com's authentication/authorization API"
  s.description       = "A wrapper for the Globo.com's authentication/authorization API"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths     = %w(lib)
  
  s.add_dependency 'nokogiri'
  s.add_dependency 'active_support'
  s.add_dependency 'builder'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'fakeweb'
end
