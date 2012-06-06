require 'rubygems'
require 'benchmark'
require 'curb'
require 'restclient'
require 'faraday'

n = 100
#url = "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/email/fab1@spam.la"
url = "http://globo.com"

Benchmark.bm do |x|
  x.report("restclient") { n.times { RestClient.get(url) } }
  x.report("curb") { n.times { Curl::Easy.perform(url) } }
  x.report("faraday") { n.times { Faraday.get(url) } }
end
