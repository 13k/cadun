require 'spec_helper'

describe Cadun::Gateway do
  let(:connection) { mock }
  let(:response) { mock }
  
  before { load_config }
  
  describe "#content" do
    let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
    
    context "when status not AUTORIZADO" do
      before do
        mock(gateway).connection { connection }

        mock(response).body { "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>NAO_AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>" }
        mock(connection).put("/ws/rest/autorizacao", "<?xml version=\"1.0\" encoding=\"UTF-8\"?><usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID type=\"integer\">2626</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}) { response }
      end
      
      it { proc { gateway.content }.should raise_error(RuntimeError, "not authorized") }
    end

    context "when status AUTORIZADO" do
      before do
        mock(gateway).connection.twice { connection }

        mock(response).body { "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>" }
        mock(connection).put("/ws/rest/autorizacao", "<?xml version=\"1.0\" encoding=\"UTF-8\"?><usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID type=\"integer\">2626</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}) { response }
        mock(response).body { "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>" }
        mock(connection).get("/cadunii/ws/resources/pessoa/1", {'Content-Type' => 'text/xml'}) { response }
      end
      
      it { proc { gateway.content }.should_not raise_error(RuntimeError, "not authorized") }
      
      it "should parse the resource" do
        gateway.content['nome'].should == 'Barack Obama'
      end
    end
  end
  
  describe "#authorization" do
    context "when all information is given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
      
      before do
        mock(gateway).connection { connection }

        mock(response).body { "<?xml version='1.0' encoding='utf-8'?><usuarioAutorizado><status>AUTORIZADO</status><usuarioID>1</usuarioID></usuarioAutorizado>" }
        mock(connection).put("/ws/rest/autorizacao", "<?xml version=\"1.0\" encoding=\"UTF-8\"?><usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID type=\"integer\">2626</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}) { response }
      end

      it "should parse the authorization request" do
        gateway.authorization['usuarioID'].should == '1'
      end

    end
    
    context "when glb_id is not given" do
      let(:gateway) { Cadun::Gateway.new }
      it { proc { gateway.authorization }.should raise_error(RuntimeError, "glb_id is missing") }
    end
    
    context "when ip is not given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "1") }
      it { proc { gateway.authorization }.should raise_error(RuntimeError, "ip is missing") }
    end
    
    context "when service_id is not given" do
      let(:gateway) { Cadun::Gateway.new(:glb_id => "1", :ip => "1") }
      it { proc { gateway.authorization }.should raise_error(RuntimeError, "service_id is missing") }
    end
  end
  
  describe "#provision" do
    let(:gateway) { Cadun::Gateway.new }
    
    context "when the service is provisioned to the user" do
      before do
        mock(gateway).connection { connection }

        mock(response).code { "200" }
        mock(connection).put("/service/provisionamento", "{\"usuarioId\": \"123456\", \"servicoId\": \"2515\"}", {'Content-Type' => 'application/json'}) { response }
      end
      
      subject { gateway.provision(123456, 2515) }
      specify { should be_true }
    end
    
    context "when the service is provisioned to the user" do
      before do
        mock(gateway).connection { connection }

        mock(response).code { "304" }
        mock(connection).put("/service/provisionamento", "{\"usuarioId\": \"123456\", \"servicoId\": \"2515\"}", {'Content-Type' => 'application/json'}) { response }
      end
      
      subject { gateway.provision(123456, 2515) }
      specify { should be_false }
    end
  end
end
