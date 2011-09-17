require 'spec_helper'

describe Cadun::Gateway do  
  before { load_config }
  
  describe "#provision" do
    subject { Cadun::Gateway.provision(123456, 2515) }
    
    context "when the service is provisioned to the user" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [200]) }
      specify { should be_true }
    end
  
    context "when the service has been provisioned to the user" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [304]) }
      specify { should be_false }
    end
    
    context "when the service is not found" do
      before { stub_request(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento").to_return(:status => [404]) }
      specify { should be_false }
    end
  end
  
  describe "#content" do
    let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
    subject { gateway.content }
    
    context "when status not AUTORIZADO" do
      before { stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>NAO_AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>") }
      it { proc { subject }.should raise_error(Exception) }
    end

    context "when status AUTORIZADO" do
      before do
        stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>")
        stub_request(:get, "http://isp-authenticator.qa01.globoi.com:8280/cadunii/ws/resources/pessoa/1").to_return(:body => "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>")
      end

      specify { should include('nome' => 'Barack Obama') }
    end
  end
  
  describe "#authorization" do
    subject { proc { gateway.authorization } }
    
    context "when all information is given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
      before { stub_request(:put, "http://isp-authenticator.qa01.globoi.com:8280/ws/rest/autorizacao").to_return(:body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID type=\"integer\">2626</servicoID></usuarioAutorizado>", :body => "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>") }
      it { subject.call.should include('usuarioID' => '1') }
    end
    
    context "when glb_id is not given" do
      let(:gateway) { Cadun::Gateway.new }
      specify { should raise_error(ArgumentError, "glb_id is missing") }
    end
    
    context "when ip is not given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "1") }
      specify { should raise_error(ArgumentError, "ip is missing") } 
    end
    
    context "when service_id is not given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "1", :ip => "1") }
      specify { should raise_error(ArgumentError, "service_id is missing") }
    end
  end
end