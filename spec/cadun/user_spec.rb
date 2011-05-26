# encoding: utf-8
require 'spec_helper'

describe Cadun::User do
  
  def self.verify_method(method, value)
    describe "##{method}" do
      specify { subject.send(method).should == value }
    end
  end
  
  before do
    load_config
    stub_requests
  end
  
  context "when the user id is not given" do
    subject { Cadun::User.new :ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID" }
    
    it "should load the gateway" do
      mock(Cadun::Gateway).new(hash_including(:ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID"))
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

    verify_method "user_type", "NAO_ASSINANTE"
    
    verify_method "user_id", "21737810"
  end
  
  context "when the user id is given" do
    subject { Cadun::User.new :user_id => "10001000" }
    
    it "should load the gateway" do
      mock(Cadun::Gateway).new(hash_including(:user_id => "10001000"))
      subject
    end

    verify_method "id", "10001000"

    verify_method "name", "Guilherme Chico"
  end
  
  describe "#to_hash" do
    subject { Cadun::User.new(:user_id => "10001000").to_hash }
    
    specify { should include(:user_id => "10001000") }
    specify { should include(:name => "Guilherme Chico") }
    specify { should include(:email => "fab1@spam.la") }
    specify { should include(:user_type => "NAO_ASSINANTE") }
    specify { should include(:gender => "MASCULINO") }
    specify { should include(:neighborhood => "Andaraí") }
    specify { should include(:city => "Rio de Janeiro") }
    specify { should include(:state => "RJ") }
    specify { should include(:country => "Brasil") }
    specify { should include(:address => "Rua Uruguai, 59") }
    specify { should include(:birthday => Date.new(1983, 02, 22)) }
    specify { should include(:phone => "21 22881060") }
    specify { should include(:mobile => "21 99999999") }
    specify { should include(:login => "fabricio_fab1") }
    specify { should include(:cpf => "09532034765") }
    specify { should include(:zipcode => "20510060") }
    specify { should include(:status => "ATIVO") }
  end
end