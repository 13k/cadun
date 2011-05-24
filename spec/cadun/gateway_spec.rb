require 'spec_helper'

describe Cadun::Gateway do
  let(:connection) { mock }
  let(:response) { mock }
  
  before do
    load_config
    mock(subject).connection { connection }
  end
  
  subject { Cadun::Gateway.new("GLB_ID", "127.0.0.1", 2626) }
  
  describe "#content" do
    before do
      mock(subject).authorization { mock(mock).xpath("usuarioID") { mock(mock).text { "1" } } }
      mock(response).body { "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>" }
      mock(connection).get("/cadunii/ws/resources/pessoa/1", { 'Content-Type' => 'text/xml' }) { response }
    end
    
    it "should parse the resource" do
      subject.content.xpath('nome').text.should == 'Barack Obama'
    end
  end
  
  describe "#authorization" do
    before do
      mock(response).body { "<?xml version='1.0' encoding='utf-8'?><pessoa><usuarioID>1</id></usuarioID>" }
      mock(connection).put("/ws/rest/autorizacao", "<usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID>2626</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}) { response }
    end
    
    it "should parse the authorization request" do
      subject.authorization.xpath('usuarioID').text.should == '1'
    end
  end
end