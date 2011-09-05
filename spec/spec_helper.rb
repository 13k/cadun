require "#{File.dirname(__FILE__)}/../lib/cadun"
require 'webmock/rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|  
  config.mock_with :rr
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  
  config.before(:suite) do
    WebMock.disable_net_connect!(:allow_localhost => true)
  end
end

def stub_requests
  stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/autorizacao.xml"))
  stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/21737810").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/pessoa.xml"))
  stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/10001000").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/pessoa_2.xml"))
  stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/email/silvano@globo.com").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/email.xml"))
  stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/email/silvano@corp.globo.com").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/email.xml"))
  stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/email/fulano_adm_campanha@globomail.com").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/email2.xml"))
  stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/provisionamento.json"))
end

def load_config
  Cadun::Config.load_file "#{File.dirname(__FILE__)}/support/fixtures/config.yml"
end

def load_another_config
  Cadun::Config.load_file "#{File.dirname(__FILE__)}/support/fixtures/another_config.yml"
end