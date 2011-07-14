module Cadun
  module Gateway
    class Provisioning < Base
      def provision(user_id, service_id)
        path  = "/service/provisionamento"
        data  = %Q{{"usuarioId":"#{user_id}","servicoId":"#{service_id}"}}
        put(path, data) == "200"
      end
      
      def put(path, data)
        connection.put(path, data, {'Content-Type' => 'application/json'}).code
      end
      
      def connection
        @connection ||= Net::HTTP.new(Config.restclient_url)
      end
    end
  end
end