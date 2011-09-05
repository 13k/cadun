require 'spec_helper'

describe Cadun::Gateway do  
  before { load_config }
  
  describe "#provision" do  
    context "when the service is provisioned to the user" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [200]) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      specify { should be_true }
    end
  
    context "when the service is provisioned to the user" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [304]) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      it { subject.should be_false }
    end
    
    context "when the service is not found" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [404]) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      it { subject.should be_false }
    end
    
    context "when the service is not found" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [503]) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      it { subject.should be_false }
    end
    
  end
  
  describe "#content" do
    let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
    
    context "when status not AUTORIZADO" do
      before do
        stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>NAO_AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
      end
      
      it { proc { gateway.content }.should raise_error(Exception) }
    end

    context "when status AUTORIZADO" do
      before do
        stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
        stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/1").to_return(:body => "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>")
      end
      
      it { proc { gateway.content }.should_not raise_error(Exception) }
      
      it "should parse the resource" do
        gateway.content['nome'].should == 'Barack Obama'
      end
    end
  end
  
  describe "#authorization" do
    context "when all information is given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
      
      before do
        stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID type=\"integer\">2626</servicoID></usuarioAutorizado>", :body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
      end

      it "should parse the authorization request" do
        gateway.authorization['usuarioID'].should == '1'
      end

    end
    
    context "when glb_id is not given" do
      let(:gateway) { Cadun::Gateway.new }
      it { proc { gateway.authorization }.should raise_error(ArgumentError, "glb_id is missing") }
    end
    
    context "when ip is not given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "1") }
      it { proc { gateway.authorization }.should raise_error(ArgumentError, "ip is missing") }
    end
    
    context "when service_id is not given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "1", :ip => "1") }
      it { proc { gateway.authorization }.should raise_error(ArgumentError, "service_id is missing") }
    end
  end
end