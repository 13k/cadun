# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require "cadun"

Gem::Specification.new do |s|
  s.name        = "cadun"
  s.version     = Cadun::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bruno Azisaka Maciel"]
  s.email       = ["bruno@azisaka.com.br"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""

  s.rubyforge_project = "cadun"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'nokogiri'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'fakeweb'
end
