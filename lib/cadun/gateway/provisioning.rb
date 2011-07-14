module Cadun
  module Gateway
    class Provisioning < Authorization
      def provision(user_id, service_id)
        connection.put("/service/provisionamento", "{\"usuarioId\":\"#{user_id}\",\"servicoId\":\"#{service_id}\"}").status == 200
      end
      
      protected
      def setup!
        @connection = Patron::Session.new
        @connection.base_url = Config.restclient_url
        @connection.headers['Content-Type'] = 'application/json'
      end
    end
  end
end