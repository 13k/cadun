module Cadun
  class Gateway
    def initialize(glb_id, ip, service_id)
      @glb_id, @ip, @service_id = glb_id, ip, service_id
    end

    def content
      @content ||= Nokogiri::XML(content_resource).children
    end

    def authorization
      @authorization ||= Nokogiri::XML(authorization_resource).children
    end

    def connection
      @connection ||= Net::HTTP.new(Config.auth_url, Config.auth_port)
    end
    
    protected
    def content_resource
      get "/cadunii/ws/resources/pessoa/#{authorization.xpath("usuarioID").text}"
    end

    def get(path)
      connection.get(path, {'Content-Type' => 'text/xml'}).body
    end
    
    def authorization_resource
      put "/ws/rest/autorizacao", "<usuarioAutorizado><glbId>#{@glb_id}</glbId><ip>#{@ip}</ip><servicoID>#{@service_id}</servicoID></usuarioAutorizado>"
    end
    
    def put(path, data)
      connection.put(path, data, {'Content-Type' => 'text/xml'}).body
    end
  end
end