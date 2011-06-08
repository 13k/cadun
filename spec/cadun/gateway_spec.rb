require 'spec_helper'

describe Cadun::Gateway do
  let(:connection) { mock }
  let(:response) { mock }
  
  before { load_config }
  
  describe "#content" do
    subject { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
    
    before do
      mock(subject).connection { connection }
      
      mock(subject).authorization { mock(mock).xpath("usuarioID") { mock(mock).text { "1" } } }
      mock(response).body { "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>" }
      mock(connection).get("/cadunii/ws/resources/pessoa/1", { 'Content-Type' => 'text/xml' }) { response }
    end
    
    it "should parse the resource" do
      subject.content.xpath('nome').text.should == 'Barack Obama'
    end
  end
  
  describe "#authorization" do
    context "when all information is given" do
      subject { Cadun::Gateway.new(:glb_id => "GLB_ID", :ip => "127.0.0.1", :service_id => 2626) }
      
      before do
        mock(subject).connection { connection }

        mock(response).body { "<?xml version='1.0' encoding='utf-8'?><pessoa><usuarioID>1</id></usuarioID>" }
        mock(connection).put("/ws/rest/autorizacao", "<usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID>2626</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}) { response }
      end

      it "should parse the authorization request" do
        subject.authorization.xpath('usuarioID').text.should == '1'
      end
    end
    
    context "when glb_id is not given" do
      subject { Cadun::Gateway.new }
      
      it { proc { subject.authorization }.should raise_error(RuntimeError, "glb_id is missing") }
    end
    
    context "when ip is not given" do
      subject { Cadun::Gateway.new(:glb_id => "1") }
      
      it { proc { subject.authorization }.should raise_error(RuntimeError, "ip is missing") }
    end
    
    context "when service_id is not given" do
      subject { Cadun::Gateway.new(:glb_id => "1", :ip => "1") }
      
      it { proc { subject.authorization }.should raise_error(RuntimeError, "service_id is missing") }
    end
  end
end