require 'spec_helper'

describe Cadun::Config do
  def self.verify_method(method, value)
    describe "##{method}" do
      subject { Cadun::Config.send(method) }
      specify { should == value }
    end
  end
  
  before { load_config }
  
  verify_method "login_url", "https://login.qa01.globoi.com/login"
                
  verify_method "logout_url", "https://login.qa01.globoi.com/Servlet/do/logout"
                
  verify_method "auth_url", "http://isp-authenticator.qa01.globoi.com:8280"
  
  context "when the file changes" do
    
    before { load_another_config }

    verify_method "login_url", "https://login.globo.com/login"
                  
    verify_method "logout_url", "https://login.globo.com/Servlet/do/logout"
                  
    verify_method "auth_url", "http://autenticacao.globo.com:8080"
  end
end