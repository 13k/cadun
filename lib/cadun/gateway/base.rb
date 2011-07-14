module Cadun
  module Gateway
    class Base
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
      
        put "/ws/rest/autorizacao", { "glbId" => options[:glb_id], "ip" => options[:ip], "servicoID" => options[:service_id] }.to_xml(:root => "usuarioAutorizado", :indent => 0)
      end
    
      def put(path, data)
        connection.put(path, data, {'Content-Type' => 'text/xml'}).body
      end
    end
  end
end