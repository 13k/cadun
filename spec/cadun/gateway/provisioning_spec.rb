require 'spec_helper'

describe Cadun::Gateway::Provisioning do
  let(:connection) { mock }
  let(:response) { mock }
  
  before { load_config }
  
  describe "#provision" do
    let(:gateway) { Cadun::Gateway::Provisioning.new }
  
    context "when the service is provisioned to the user" do
      before do
        mock(gateway).connection { connection }

        mock(response).code { "200" }
        mock(connection).put("/service/provisionamento", "{\"usuarioId\":\"123456\",\"servicoId\":\"2515\"}", {'Content-Type' => 'application/json'}) { response }
      end
    
      subject { gateway.provision(123456, 2515) }
      specify { should be_true }
    end
  
    context "when the service is provisioned to the user" do
      before do
        mock(gateway).connection { connection }

        mock(response).code { "304" }
        mock(connection).put("/service/provisionamento", "{\"usuarioId\":\"123456\",\"servicoId\":\"2515\"}", {'Content-Type' => 'application/json'}) { response }
      end
    
      subject { gateway.provision(123456, 2515) }
      specify { should be_false }
    end
  end
end