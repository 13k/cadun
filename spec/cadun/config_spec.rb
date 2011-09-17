require 'spec_helper'

describe Cadun::Config do
  before { load_config }
  subject { Cadun::Config }
  
  its(:login_url)  { should == "https://login.qa01.globoi.com/login" }
  its(:logout_url) { should == "https://login.qa01.globoi.com/Servlet/do/logout" }
  its(:auth_url)   { should == "http://isp-authenticator.qa01.globoi.com:8280" }
  
  context "when the file changes" do
    before { load_another_config }
    its(:login_url) { should == "https://login.globo.com/login" }
    its(:logout_url) { should == "https://login.globo.com/Servlet/do/logout" }
    its(:auth_url) { should == "http://autenticacao.globo.com:8080" }
  end
end