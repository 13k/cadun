require 'spec_helper'

describe Cadun::Gateway::Provisioning do  
  before { load_config }
  
  describe "#provision" do
    let(:gateway) { Cadun::Gateway::Provisioning.new }
  
    context "when the service is provisioned to the user" do
      before do
        FakeWeb.register_uri(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento", :status => 200)
      end
    
      subject { gateway.provision(123456, 2515) }
      specify { should be_true }
    end
  
    context "when the service is provisioned to the user" do
      before do
        FakeWeb.register_uri(:put, "http://cadun-rest.qa01.globoi.com/service/provisionamento", :status => 304)
      end
    
      subject { gateway.provision(123456, 2515) }
      specify { should be_false }
    end
  end
end