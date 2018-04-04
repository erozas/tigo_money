module TigoMoney
  class SyncPaymentResponse < Response
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def formatted
      resp = self.class.from_savon(@response)
      resp_body = resp.raw_body[:solicitar_pago_response][:return]
      handle_response Formatter.format_response(Decryptor.decrypt(resp_body))
    end

    private

    def handle_response(resp)
      response_code = resp["response_code"].to_i
      if response_code == 0
        handle_successful_response(resp)
      else
        handle_error_response(resp)
      end
    end

    def handle_successful_response(response)
      JSON.generate(response)
    end

    def handle_error_response(response)
      puts "Handling error response"
      puts response
    end
  end
end