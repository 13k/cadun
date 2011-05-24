# encoding: utf-8
require 'spec_helper'

describe Cadun::User do
  include Cadun
  
  subject { User.new "GLB_ID", "127.0.0.1", 2626 }
  
  def self.verify_method(method, value)
    describe "##{method}" do
      specify { subject.send(method).should == value }
    end
  end
  
  before do
    load_config
    stub_requests
  end
  
  it "should load the gateway" do
    mock(Gateway).new "GLB_ID", "127.0.0.1", 2626
    subject
  end
                
  verify_method "id", "21737810"
                
  verify_method "name", "Fabricio Rodrigo Lopes"
                
  verify_method "birthday", Date.new(1983, 02, 22)
                
  verify_method "phone", "21 22881060"
                
  verify_method "mobile", "21 99999999"
                
  verify_method "email", "fab1@spam.la"
                
  verify_method "gender", "MASCULINO"
                
  verify_method "city", "Rio de Janeiro"
                
  verify_method "state", "RJ"
                
  verify_method "status", "ATIVO"
                
  verify_method "address", "Rua Uruguai, 59"
                
  verify_method "neighborhood", "Andaraí"
                
  verify_method "cpf", "09532034765"
                
  verify_method "login", "fabricio_fab1"
                
  verify_method "country", "Brasil"
end