module Cadun
  class Gateway
    def initialize(glb_id, ip, service_id)
      @glb_id, @ip, @service_id = glb_id, ip, service_id
    end

    def content
      @content ||= Nokogiri::XML(resource).children
    end

    def authorization
      @authorization ||= Nokogiri::XML(connection.put("/ws/rest/autorizacao", "<usuarioAutorizado><glbId>#{@glb_id}</glbId><ip>#{@ip}</ip><servicoID>#{@service_id}</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}).body).children
    end

    def resource
      @resource ||= connection.get("/cadunii/ws/resources/pessoa/#{authorization.xpath("usuarioID").text}", {'Content-Type' => 'text/xml'}).body
    end

    def connection
      @connection ||= Net::HTTP.new(*[Config.auth_url, Config.auth_port])
    end
  end
end