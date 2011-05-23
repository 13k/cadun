require 'spec_helper'

describe Cadun::Config do
  before do
    Cadun::Config.load_file File.join(File.dirname(__FILE__), "..", "support", "fixtures", "config.yml")
  end
  
  describe "#login_url" do
    subject { Cadun::Config.login_url }

    specify { should == "https://login.dev.globoi.com/login" }
  end
  
  describe "#logout_url" do
    subject { Cadun::Config.logout_url }

    specify { should == "https://login.dev.globoi.com/Servlet/do/logout" }
  end
  
  describe "#auth_url" do
    subject { Cadun::Config.auth_url }

    specify { should == "isp-authenticator.dev.globoi.com" }
  end
  
  describe "#auth_port" do
    subject { Cadun::Config.auth_port }

    specify { should == 8280 }
  end
  
  context "when the file changes" do
    before do
      Cadun::Config.load_file File.join(File.dirname(__FILE__), "..", "support", "fixtures", "another_config.yml")
    end

    describe "#login_url" do
      subject { Cadun::Config.login_url }

      specify { should == "https://login.globo.com/login" }
    end

    describe "#logout_url" do
      subject { Cadun::Config.logout_url }

      specify { should == "https://login.globo.com/Servlet/do/logout" }
    end

    describe "#auth_url" do
      subject { Cadun::Config.auth_url }

      specify { should == "autenticacao.globo.com" }
    end

    describe "#auth_port" do
      subject { Cadun::Config.auth_port }

      specify { should == 8080 }
    end
  end
end