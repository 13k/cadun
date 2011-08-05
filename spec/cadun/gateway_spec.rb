require 'spec_helper'

describe Cadun::Gateway do  
  before { load_config }
  
  describe "#provision" do  
    context "when the service is provisioned to the user" do
      before { FakeWeb.register_uri(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento", :status => 200) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      specify { should be_true }
    end
  
    context "when the service is provisioned to the user" do
      before { FakeWeb.register_uri(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento", :status => 304) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      it { proc { subject }.should raise_error(RestClient::NotModified) }
    end
    
    context "when the service is not found" do
      before { FakeWeb.register_uri(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento", :status => 404) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      it { proc { subject }.should raise_error(RestClient::ResourceNotFound) }
    end
    
    context "when the service is not found" do
      before { FakeWeb.register_uri(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento", :status => 503) }
    
      subject { Cadun::Gateway.provision(123456, 2515) }
      it { proc { subject }.should raise_error(RestClient::ServiceUnavailable) }
    end
    
  end
  
  describe "#content" do
    let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
    
    context "when status not AUTORIZADO" do
      before do
        FakeWeb.register_uri(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao", :body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>NAO_AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
      end
      
      it { proc { gateway.content }.should raise_error(Exception) }
    end

    context "when status AUTORIZADO" do
      before do
        FakeWeb.register_uri(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao", :body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
        FakeWeb.register_uri(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/1", :body => "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>")
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
        FakeWeb.register_uri(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao", :body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID type=\"integer\">2626</servicoID></usuarioAutorizado>", :body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
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