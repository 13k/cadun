module Cadun
  class User    
    { "id"             => "cadun_id", 
      "nome"           => "name", 
      "emailPrincipal" => "email",
      "tipoUsuario"    => "user_type", 
      "sexo"           => "gender",
      "bairro"         => "neighborhood", 
      "cep"            => "zipcode",
      "complemento"    => "complement" }.each { |path, method| define_method(method) { gateway.content[path] } }
    
    alias :id :cadun_id
    
    def self.find_by_email(email)
      email = "#{email}@globo.com" unless email =~ /^.*@.*$/
      new(:email => email)
    end
    
    def self.find_by_id(cadun_id)
      new(:cadun_id => cadun_id)
    end
    
    def initialize(options = {})
      @options = options
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
      %w(address birthday cadun_id city complement country cpf email gender login mobile name neighborhood phone state status user_type zipcode).inject(Hash.new(0)) { |hash, method| hash[method.to_sym] = send(method); hash }
    end
    
    def provision_to_service(service_id)
      Gateway.provision(id, service_id)
    end
    
    def method_missing(method)
      gateway.content[method.to_s]
    end
    
    def gateway
      @gateway ||= Gateway.new(@options)
    end
  end
end