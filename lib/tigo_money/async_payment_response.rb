module TigoMoney
  class AsyncPaymentResponse < Response
    attr_accessor :formatted_response

    def self.formatted_response response
      resp = Response.from_savon response
      resp_body = resp.raw_body[:solicitar_pago_asincrono_response][:return]
      final_resp = JSON.generate(Formatter.format_response(Decryptor.decrypt(resp_body)))
    end
  end
end