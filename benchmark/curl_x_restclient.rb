require 'rubygems'
require 'benchmark'
require 'curb'
require 'restclient'

n = 100
url = "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/email/fab1@spam.la"

Benchmark.bm do |x|
  x.report("restclient") { n.times { RestClient.get(url) } }
  x.report("curb") { n.times { Curl::Easy.perform(url) } }
end