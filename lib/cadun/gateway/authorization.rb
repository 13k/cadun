module Cadun
  module Gateway
    class Authorization
      attr_reader :options, :connection
    
      def initialize(options = {})        
        @options = options
        setup!
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
      
        connection.get("/cadunii/ws/resources/pessoa/#{subject}").body
      end
    
      def authorization_resource
        [:glb_id, :ip, :service_id].each { |arg| raise RuntimeError.new("#{arg} is missing") unless options[arg] }
      
        connection.put("/ws/rest/autorizacao", {
          "glbId" => options[:glb_id],
          "ip" => options[:ip],
          "servicoID" => options[:service_id]
        }.to_xml(:root => "usuarioAutorizado", :indent => 0)).body
      end
      
      def setup!
        @connection = Patron::Session.new
        @connection.base_url = Config.auth_url
        @connection.headers['Content-Type'] = 'text/xml'
      end
    end
  end
end