require "#{File.dirname(__FILE__)}/../lib/cadun"
require 'fakeweb'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before :suite do
    FakeWeb.allow_net_connect = false
  end
  
  config.before :each do
    FakeWeb.clean_registry
  end
  
  config.mock_with :rr
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

def stub_requests
  FakeWeb.register_uri :put, "http://isp-authenticator.dev.globoi.com:8280/ws/rest/autorizacao",
                       :body => "#{File.dirname(__FILE__)}/support/fixtures/autorizacao.xml"

  FakeWeb.register_uri :get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/21737810", 
                       :body => "#{File.dirname(__FILE__)}/support/fixtures/pessoa.xml"
                       
  FakeWeb.register_uri :get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/10001000", 
                       :body => "#{File.dirname(__FILE__)}/support/fixtures/pessoa_2.xml"
                       
  FakeWeb.register_uri :get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/email/silvano@globo.com", 
                       :body => "#{File.dirname(__FILE__)}/support/fixtures/email.xml"
                       
  FakeWeb.register_uri :get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/email/silvano@corp.globo.com", 
                       :body => "#{File.dirname(__FILE__)}/support/fixtures/email.xml"
  
 FakeWeb.register_uri :put, "http://isp-authenticator.dev.globoi.com:8280/service/provisionamento",
                      [{ :body => "#{File.dirname(__FILE__)}/support/fixtures/provisionamento.json" }, { :code => 200 }]                    
                       
end

def load_config
  Cadun::Config.load_file "#{File.dirname(__FILE__)}/support/fixtures/config.yml"
end

def load_another_config
  Cadun::Config.load_file "#{File.dirname(__FILE__)}/support/fixtures/another_config.yml"
end