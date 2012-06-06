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
  
  s.add_dependency 'i18n'
  s.add_dependency 'json'
  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'builder', '>= 2.1.2'
  s.add_dependency 'faraday', '~> 0.8.1'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'webmock'
end
