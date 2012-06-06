# encoding: utf-8
require 'spec_helper'

describe Cadun::User do
  before do
    load_config
    stub_requests
  end
  
  context "when the user id is not given" do
    subject { Cadun::User.new :ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID" }
    
    it "should load the gateway only when it's needed" do
      mock(Cadun::Gateway).new(hash_including(:ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID")) do 
        mock(Cadun::Gateway).content { Hash.new }
      end
      
      subject.login
    end
    
    it "should not load the gateway when the user is initialized" do
      dont_allow(Cadun::Gateway).new
      subject
    end

    its(:id)            { should == "21737810" }
    its(:name)          { should == "Fabricio Rodrigo Lopes" }
    its(:birthday)      { should == Date.new(1983, 02, 22) }
    its(:phone)         { should == "21 22881060" }
    its(:mobile)        { should == "21 99999999" }
    its(:email)         { should == "fab1@spam.la" }
    its(:gender)        { should == "MASCULINO" }
    its(:city)          { should == "Rio de Janeiro" }
    its(:state)         { should == "RJ" }
    its(:status)        { should == "ATIVO" }
    its(:address)       { should == "Rua Uruguai, 59" }
    its(:neighborhood)  { should == "Andaraí" }
    its(:cpf)           { should == "09532034765" }
    its(:login)         { should == "fabricio_fab1" }
    its(:country)       { should == "Brasil" }
    its(:user_type)     { should == "NAO_ASSINANTE" }
    its(:cadun_id)      { should == "21737810" }
    its(:complement)    { should == "807" }
  end
  
  describe "#to_hash" do
    context "when the user has all data" do
      subject { Cadun::User.new(:cadun_id => "10001000").to_hash }
      
      specify { should include(:cadun_id => "10001000") }
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
      specify { should include(:complement => "807") }
    end
    
    context "when the user has minimal data" do
      subject { Cadun::User.find_by_email("fulano_adm_campanha@globomail.com") }
      
      its(:id)      { should == "23370159" }
      its(:city)    { should be_nil }
      its(:state)   { should be_nil }
      its(:country) { should be_nil }
    end
  end
  
  describe ".find_by_email" do
    context "given an email without domain" do
      subject { Cadun::User.find_by_email("silvano") }
      its(:id) { should == "24510533" }
    end
    
    context "given an email with domain" do
      subject { Cadun::User.find_by_email("silvano@corp.globo.com") }
      its(:id) { should == "24510533" }
    end
  end
  
  describe ".find_by_id" do
    subject { Cadun::User.find_by_id("10001000") }
    its(:id) { should == "10001000" }
  end
  
  describe "#provision_to_service" do
    it "should call gateway's provision" do
      mock(Cadun::Gateway).provision(1, 6969)
      
      user = Cadun::User.new
      mock(user).id { 1 }
      user.provision_to_service(6969)
    end
  end
end
