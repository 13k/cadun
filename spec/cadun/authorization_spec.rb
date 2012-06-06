# encoding: utf-8
require 'spec_helper'

describe Cadun::Authorization do
  before do
    load_config
    stub_requests
  end

  context "authorization request" do
    subject { Cadun::Authorization.new :ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID" }

    it "should load the gateway only when it's needed" do
      mock(Cadun::Gateway).new(hash_including(:ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID")) do
        mock(Cadun::Gateway).content { Hash.new }
      end

      subject.cadun_id
    end

    it "should not load the gateway when the object is initialized" do
      dont_allow(Cadun::Gateway).new
      subject
    end

    its(:id)            { should == "21737810" }
    its(:cadun_id)      { should == "21737810" }
    its(:email)         { should == "fab1@spam.la" }
    its(:glbid)         { should == "1484e00106ea401d57902541631200e8a6d44556132366c754c4261655666625537614531655252536e6262626c63676676436c6c316744544d5636617651707a6d417a49756b6e3830415a4a394f36773a303a66616231407370616d2e6c61" }
    its(:login)         { should == "fab1@spam.la" }
    its(:status)        { should == "AUTORIZADO" }
    its(:state)         { should == "ATIVO" }
    its(:user_type)     { should == "NAO_ASSINANTE" }
    its(:username)      { should == "fabricio_fab1" }
    its(:ip)            { should == "10.2.25.160" }
  end

  describe "#to_hash" do
    subject { Cadun::Authorization.new(:ip => "127.0.0.1", :service_id => 2626, :glb_id => "GLB_ID").to_hash }

    specify { should include(:cadun_id => "21737810") }
    specify { should include(:email => "fab1@spam.la") }
    specify { should include(:glbid => "1484e00106ea401d57902541631200e8a6d44556132366c754c4261655666625537614531655252536e6262626c63676676436c6c316744544d5636617651707a6d417a49756b6e3830415a4a394f36773a303a66616231407370616d2e6c61") }
    specify { should include(:login => "fab1@spam.la") }
    specify { should include(:status => "AUTORIZADO") }
    specify { should include(:state => "ATIVO") }
    specify { should include(:user_type => "NAO_ASSINANTE") }
    specify { should include(:username => "fabricio_fab1") }
    specify { should include(:ip => "10.2.25.160") }
  end
end
