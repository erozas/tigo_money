module TigoMoney
  # The TigoMoney API expects the params to be in the form of a
  # semi-colon separated key-value pair block of text.
  # This params follow a very specific format that's not necessarily readable
  # So this class responsibility is to format the params provided by the
  # HTTP request into the expected format.
  class Formatter
    PARAMS_TRANSLATION    = { id_number: "pv_nroDocumento",
                              cell_phone: "pv_linea",
                              amount: "pv_monto",
                              order_id: "pv_orderId",
                              confirmation_message: "pv_confirmacion",
                              notification_message: "pv_notificacion"}
                                 
    RESPONSE_TRANSLATION  = { codRes: "response_code",
                              mensaje: "message", 
                              orderId: "order_id",
                              transaccion: "transaction",
                              nroFactura: "invoice_name",
                              nroAutorizacion: "authorization_number",
                              codigoControl: "control_code"}

    class << self
      # In charge of formatting the input params hash before passing them
      # to the TigoMoney API. Mostly, we want the hash keys to be compatible
      # with the ones that the TigoMoney API is expecting
      def format_input params_hash
        hash_to_text_block translate_input_hash_keys(params_hash)
      end

      # In charge of formatting the response that comes back from the
      # TigoMoney API when trying to execute sync and async payments
      def format_response response 
        translate_response_hash_keys response_to_hash(response)
      end

      # In charge of formatting the response that comes back when checking
      # a given transaction status. Said response is a string with the following form:
      # Successful response: 0;vacio;transaccion=15996357
      # Error response: 1;vacio;motivo=10020
      def format_status_response response
        resp_arr = response.split(";")

        case resp_arr[0].to_i
          when 0
            build_success_status_hash(resp_arr)
          when 1
            build_error_status_hash(resp_arr)
          when 2
            build_reverted_status_hash(resp_arr)
          when 3
            build_in_progress_status_hash(resp_arr)
        end

      end
      
      private
      def hash_to_text_block(hash)
        hash.map {|k,v| "#{k}=#{v}"}.join(";") + ";"
      end

      def translate_input_hash_keys(params_hash)
        hash = {}
        params_hash.each { |k, v| hash[PARAMS_TRANSLATION[k]] = v}
        hash["pv_confirmacion"] = TigoMoney.configuration.commerce_name
        hash
      end

      def translate_response_hash_keys(hash)
        hash.keys.each do |k|
          hash[RESPONSE_TRANSLATION[k.to_sym]] = hash.delete k
        end
        hash
      end

      def response_to_hash response
        Rack::Utils.parse_nested_query response
      end

      def build_success_status_hash(response_array)
        status_hash = {
          response_code: response_array[0],
          body: response_array[1]
        }

        status_hash[:transaction_id] = response_array[2].split("=")[1] if response_array[2]

        status_hash
      end

      def build_error_status_hash(response_array)
        status_hash = {}
        
        status_hash[:response_code] = 1
        status_hash[:body] = nil
        status_hash[:error_code] = response_array[2].split("=")[1].to_i if response_array[2]
        
        status_hash
      end

      def build_in_progress_status_hash(response_array)
        puts "Building in progress status hash"
        puts response_array
      end

      def build_reverted_status_hash(response_array)
        puts "Building reverted payment status hash"
        puts response_array
      end
    end
  end
end