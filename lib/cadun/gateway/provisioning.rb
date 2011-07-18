module Cadun
  module Gateway
    class Provisioning < Authorization
      def provision(user_id, service_id)
        begin
          RestClient.put("#{Config.restclient_url}/service/provisionamento", "{\"usuarioId\": \"#{user_id}\", \"servicoId\": \"#{service_id}\"}", :content_type => "text/javascript").code == 200
        rescue RestClient::NotModified
          false
        end
      end
    end
  end
end