module Cadun
  class Gateway
    attr_reader :options
    
    def initialize(options = {})
      @options = options
    end

    def content
      @content ||= Hash.from_xml(content_resource)["pessoa"]
    end

    def authorization
      @authorization ||= Hash.from_xml(authorization_resource)["usuarioAutorizado"]
    end

    def connection
      @connection ||= Net::HTTP.new(Config.auth_url, Config.auth_port)
    end
    
    def provision(user_id, service_id)
      path  = "/service/provisionamento"
      data  = %Q{{"usuarioId":"#{user_id}","servicoId":"#{service_id}"}}
      put(path, data, "application/json").code == "200"
    end
    
    protected
    def content_resource
      subject = if options[:email]
        "email/#{options[:email]}"
        
      elsif options[:cadun_id]
        options[:cadun_id]
        
      else
        raise RuntimeError.new "not authorized" unless authorization["status"] == "AUTORIZADO"
        authorization["usuarioID"]
      end
      
      get "/cadunii/ws/resources/pessoa/#{subject}"
    end

    def get(path)
      connection.get(path, {'Content-Type' => 'text/xml'}).body
    end
    
    def authorization_resource
      [:glb_id, :ip, :service_id].each { |arg| raise RuntimeError.new("#{arg} is missing") unless options[arg] }
      
      response = put "/ws/rest/autorizacao", { "glbId" => options[:glb_id], "ip" => options[:ip], "servicoID" => options[:service_id] }.to_xml(:root => "usuarioAutorizado", :indent => 0)
      response.body
    end
    
    def put(path, data, content_type = 'text/xml')
      connection.put(path, data, {'Content-Type' => content_type})
    end
    
    
  end
end
