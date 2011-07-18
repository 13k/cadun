module Cadun
  module Gateway
    class Authorization
      attr_reader :options, :connection
    
      def initialize(options = {})        
        @options = options
      end

      def content
        @content ||= Hash.from_xml(content_resource)["pessoa"]
      end

      def authorization
        @authorization ||= Hash.from_xml(authorization_resource)["usuarioAutorizado"]
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
      
        RestClient.get("#{Config.auth_url}/cadunii/ws/resources/pessoa/#{subject}", :content_type => "text/xml")
      end
    
      def authorization_resource
        [:glb_id, :ip, :service_id].each { |arg| raise RuntimeError.new("#{arg} is missing") unless options[arg] }
        
        authorization_data = { "glbId" => options[:glb_id], "ip" => options[:ip], "servicoID" => options[:service_id] }.to_xml(:root => "usuarioAutorizado", :indent => 0)
      
        RestClient.put("#{Config.auth_url}/ws/rest/autorizacao", authorization_data, :content_type => "text/xml")
      end
    end
  end
end