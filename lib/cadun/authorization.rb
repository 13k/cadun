module Cadun
  class Authorization
    { "usuarioID"      => "cadun_id",
      "emailPrincipal" => "email",
      "glbId"          => "glbid",
      "login"          => "login",
      "status"         => "status",
      "statusUsuario"  => "state",
      "tipoUsuario"    => "user_type",
      "username"       => "username",
      "ip"             => "ip" }.each { |path, method| define_method(method) { gateway.authorization[path] } }

    alias :id :cadun_id

    def initialize(options = {})
      @options = options
    end

    def to_hash
      %w(cadun_id email glbid login status state user_type username ip).inject(Hash.new(0)) { |hash, method| hash[method.to_sym] = (send(method) rescue nil); hash }
    end

    def method_missing(method)
      gateway.authorization[method.to_s]
    end

    def gateway
      @gateway ||= Gateway.new(@options)
    end
  end
end
