require 'spec_helper'

describe Cadun::Gateway do
  before { load_config }
  
  subject { Cadun::Gateway.new("GLB_ID", "127.0.0.1", 2626) }
  
  describe "#content" do
    it "should parse the resource" do
      connection = mock
      response = mock
      body = "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>"
      mock(response).body { body }
      
      mock(subject).authorization { Nokogiri::XML("<?xml version='1.0' encoding='utf-8'?><pessoa><usuarioID>1</usuarioID></pessoa>").children }
      mock(connection).get("/cadunii/ws/resources/pessoa/1", {'Content-Type' => 'text/xml'}) { response }
      mock(subject).connection { connection }
      
      subject.content.xpath('nome').text.should == 'Barack Obama'
    end
  end
  
  describe "#authorization" do
    it "should parse the authorization request" do
      connection = mock
      response = mock
      mock(response).body { "<?xml version='1.0' encoding='utf-8'?><pessoa><usuarioID>1</id></usuarioID>" }
      mock(connection).put("/ws/rest/autorizacao", "<usuarioAutorizado><glbId>GLB_ID</glbId><ip>127.0.0.1</ip><servicoID>2626</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}) { response }
      mock(subject).connection { connection }
      
      subject.authorization.xpath('usuarioID').text.should == '1'
    end
  end
  
  describe "#resource" do
    it "should parse the resource request" do
      connection = mock
      response = mock
      body = "<?xml version='1.0' encoding='utf-8'?><pessoa><nome>Barack Obama</nome></pessoa>"
      mock(response).body { body }
      
      mock(subject).authorization { Nokogiri::XML("<?xml version='1.0' encoding='utf-8'?><pessoa><usuarioID>1</usuarioID></pessoa>").children }
      mock(connection).get("/cadunii/ws/resources/pessoa/1", {'Content-Type' => 'text/xml'}) { response }
      mock(subject).connection { connection }
      
      subject.resource.should == body
    end
  end
end