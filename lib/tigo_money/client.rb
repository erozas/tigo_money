module TigoMoney
  # Executes requests against the TigoMoney API and it returns both a resource needed
  # for different operations and a response object with information on the HTTP request itself
  class Client
    attr_accessor :conn

    # Initializes the object. Expects a valid Savon connection. If it doesn't receives one
    # it initializes one with the default configuration
    def initialize(conn = nil)
      self.conn = conn || self.class.default_conn
    end

    def self.default_conn
      api_endpoint = TigoMoney.configuration.api_endpoint
      ssl_verify_mode = TigoMoney.configuration.ssl_verify_mode
      conn = Savon.client(wsdl: api_endpoint, ssl_verify_mode: ssl_verify_mode)
    end

    def execute_request(operation, plain_params)
      encrypted_params = encrypt_params(operation, plain_params)

      http_resp = conn.call(operation.to_sym, message: { key: TigoMoney.configuration.tigo_money_id, parametros: encrypted_params })

      case operation.to_s
      when "solicitar_pago"
        SyncPaymentResponse.new(http_resp).formatted
      when "solicitar_pago_asincrono"
        AsyncPaymentResponse.formatted(http_resp)
      when "consultar_estado"
        StatusCheckResponse.formatted(http_resp)
      end
    end

    private
    def encrypt_params(operation, plain_params)
      if operation.to_s == "consultar_estado"
        encrypted_params = Encryptor.encrypt(plain_params)
      else
        encrypted_params = Encryptor.encrypt(Formatter.format_input(plain_params))
      end
    end

    def handle_status_response(resp)
      puts resp
      # case resp[:status_code]
      # when 4
      #   raise AgentNotRegisteredError, "The commerce is not available for TigoMoney payments"
      # when 7
      #   raise AccessDeniedError, "You can't access shit"
      # when 8
      #   raise BadPasswordError, "Wrong password, amigo"
      # when 11
      #   raise PasswordRetryExceededError, "You're way over your limit dickwad"
      # when 1001
      #   raise InsufficientFundsError, 'You broke nigga'
      # when 1002
      #   raise TransactionRecoveredError, 'The transaction has been recovered'
      # when 1004
      #   raise WalletCapExceededError, "You've reached the limit for transactions"
      # when 1012
      #   raise PasswordRetryExceededError, "You've exceeded the password retry limit, asshat"
      # end
    end
  end
end