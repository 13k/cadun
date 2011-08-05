module Cadun
  class Gateway
    attr_reader :opts
  
    def self.provision(user_id, service_id)
      RestClient.put("#{Config.restclient_url}/service/provisionamento", "{\"usuarioId\": \"#{user_id}\", \"servicoId\": \"#{service_id}\"}", :content_type => "text/javascript").code == 200
    end
  
    def initialize(opts = {})        
      @opts = opts
    end
    
    def content
      @content ||= Hash.from_xml(content_resource)["pessoa"]
    end
  
    def content_resource
      subject = if opts[:email]; "email/#{opts[:email]}"
        elsif opts[:cadun_id]; opts[:cadun_id]
        else
          raise Exception.new(authorization["status"]) unless authorization["status"] == "AUTORIZADO"
          authorization["usuarioID"]
        end
    
      RestClient.get("#{Config.auth_url}/cadunii/ws/resources/pessoa/#{subject}", :content_type => "text/xml")
    end
    
    def authorization
      @authorization ||= Hash.from_xml(authorization_resource)["usuarioAutorizado"]
    end
  
    def authorization_resource
      %w(glb_id ip service_id).each { |i| raise ArgumentError.new("#{i} is missing") unless opts[i.to_sym] }
      authorization_data = { "glbId" => opts[:glb_id], "ip" => opts[:ip], "servicoID" => opts[:service_id] }.to_xml(:root => "usuarioAutorizado", :indent => 0)
    
      RestClient.put("#{Config.auth_url}/ws/rest/autorizacao", authorization_data, :content_type => "text/xml")
    end
  end
end