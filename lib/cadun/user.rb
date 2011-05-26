module Cadun
  class User
    attr_reader :gateway
    
    { "id"                       => "user_id", 
      "nome"                     => "name", 
      "emailPrincipal"           => "email",
      "tipoUsuario"              => "user_type", 
      "sexo"                     => "gender",
      "bairro"                   => "neighborhood", 
      "cidade/nome"              => "city", 
      "estado/sigla"             => "state",
      "pais/nome"                => "country",
      "cep"                      => "zipcode" }.each do |path, method|
      define_method(method) { gateway.content.xpath(path).text }
    end
    
    alias :id :user_id
    
    def initialize(options = {})
      @gateway = Gateway.new(options)
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
    
    def to_hash      
      %w(user_id name email user_type gender neighborhood city state country address birthday phone mobile login cpf zipcode status).inject(Hash.new(0)) { |hash, method| hash[method.to_sym] = send(method); hash }
    end
    
    def method_missing(method)
      gateway.content.xpath(method.to_s).text
    end
  end
end