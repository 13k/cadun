module Cadun
  class User
    attr_reader :authorization_gateway, :provisioning_gateway
    
    { "id"                       => "cadun_id", 
      "nome"                     => "name", 
      "emailPrincipal"           => "email",
      "tipoUsuario"              => "user_type", 
      "sexo"                     => "gender",
      "bairro"                   => "neighborhood", 
      "cep"                      => "zipcode",
      "complemento"              => "complement" }.each do |path, method|
      define_method(method) { authorization_gateway.content[path] }
    end
    
    alias :id :cadun_id
    
    def self.find_by_email(email)
      email = "#{email}@globo.com" unless email =~ /^.*@.*$/
      new(:email => email)
    end
    
    def self.find_by_id(cadun_id)
      new(:cadun_id => cadun_id)
    end
    
    def initialize(options = {})
      @authorization_gateway = Gateway::Authorization.new(options)
      @provisioning_gateway = Gateway::Provisioning.new(options)
    end
    
    def address
      "#{endereco}, #{numero}"
    end
    
    def birthday
      Date.parse(dataNascimento)
    end
  
    def phone
      "#{telefoneResidencialDdd} #{telefoneResidencial}"
    end
    
    def mobile
      "#{telefoneCelularDdd} #{telefoneCelular}"
    end
    
    def country
      pais['nome']
    end
    
    def city
      cidade['nome']
    end
    
    def state
      estado['sigla']
    end
    
    def to_hash      
      %w(cadun_id name email user_type gender neighborhood city state country address birthday phone mobile login cpf zipcode status complement).inject(Hash.new(0)) { |hash, method| hash[method.to_sym] = send(method); hash }
    end
    
    def provision_to_service(service_id)
      provisioning_gateway.provision(self.id, service_id)
    end
    
    def method_missing(method)
      authorization_gateway.content[method.to_s]
    end
  end
end