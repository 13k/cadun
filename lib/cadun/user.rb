module Cadun
  class User
    attr_reader :gateway
    
    { "id"                       => "id", 
      "nome"                     => "name", 
      "emailPrincipal"           => "email",
      "tipoUsuario"              => "user_type", 
      "sexo"                     => "gender",
      "bairro"                   => "neighborhood", 
      "cidade/nome"              => "city", 
      "estado/sigla"             => "state",
      "pais/nome"                => "country" }.each do |path, method|
      define_method(method) { gateway.content.xpath(path).text }
    end
    
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
    
    def method_missing(method)
      gateway.content.xpath(method.to_s).text
    end
  end
end