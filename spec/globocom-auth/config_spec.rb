require 'spec_helper'

describe GloboComAuth::Config do
  def self.verify_method(method, value)
    describe "##{method}" do
      subject { GloboComAuth::Config.send(method) }
      specify { should == value }
    end
  end
  
  before { load_config }
  
  verify_method "login_url", "https://login.dev.globoi.com/login"
                
  verify_method "logout_url", "https://login.dev.globoi.com/Servlet/do/logout"
                
  verify_method "auth_url", "isp-authenticator.dev.globoi.com"
                
  verify_method "auth_port", 8280
  
  context "when the file changes" do
    
    before { load_another_config }

    verify_method "login_url", "https://login.globo.com/login"
                  
    verify_method "logout_url", "https://login.globo.com/Servlet/do/logout"
                  
    verify_method "auth_url", "autenticacao.globo.com"
                  
    verify_method "auth_port", 8080
  end
end