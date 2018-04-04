module TigoMoney
  class StatusCheckResponse < Response
    attr_accessor :formatted_response
    attr_accessor :status_code

    def self.formatted_response response
      resp = Response.from_savon response
      resp_body = resp.raw_body[:consultar_estado_response][:return]
      final_resp = JSON.generate(Formatter.format_status_response Decryptor.decrypt(resp_body))
    end
  end
end