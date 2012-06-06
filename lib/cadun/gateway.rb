module Cadun
  class Gateway
    attr_reader :opts

    def self.provision(user_id, service_id)
      connection = Faraday::Connection.new Config.restclient_url, :ssl => { :verify => false }
      response = connection.put do |req|
        req.url "/service/provisionamento"
        req.headers['Content-Type'] = 'application/json'
        req.body = { "usuarioId" => user_id, "servicoId" => service_id }.to_json
      end

      response.status == 200
    end

    def initialize(opts = {})
      @opts = opts
    end

    def content
      @content ||= Hash.from_xml(content_resource)["pessoa"]
    end

    def content_resource
      Faraday.get("#{Config.auth_url}/cadunii/ws/resources/pessoa/#{subject}").body
    end

    def subject
      if opts[:email]; "email/#{opts[:email]}"
      elsif opts[:cadun_id]; opts[:cadun_id]
      else
        raise Exception.new(authorization["status"]) unless authorized?
        authorization["usuarioID"]
      end
    end

    def authorized?
      authorization["status"] == "AUTORIZADO"
    end

    def authorization
      @authorization ||= Hash.from_xml(authorization_resource)["usuarioAutorizado"]
    end

    def authorization_resource
      %w(glb_id ip service_id).each { |i| raise ArgumentError.new("#{i} is missing") unless opts[i.to_sym] }

      authorization_data = { "glbId" => opts[:glb_id], "ip" => opts[:ip], "servicoID" => opts[:service_id] }.to_xml(:root => "usuarioAutorizado", :indent => 0)

      connection = Faraday::Connection.new Config.auth_url, :ssl => { :verify => false }
      response = connection.put do |req|
        req.url "/ws/rest/autorizacao"
        req.headers['Content-Type'] = 'text/xml'
        req.body = authorization_data
      end

      response.body
    end
  end
end
