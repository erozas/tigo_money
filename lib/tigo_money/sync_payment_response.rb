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
      response_code = response["response_code"].to_i
      commerce_name = TigoMoney.configuration.commerce_name || "El comercio"
      support_email = TigoMoney.configuration.support_email || "email@example.com"

      # Raise an appropiate error according to the error code
      case response_code
      when 4
        raise AgentNotRegisteredError.new("#{commerce_name} no está habilitado para operar con TigoMoney.")
      when 7
        raise AccessDeniedError.new("Acceso denegado. Por favor, intenta nuevamente verificando los datos ingresados.")
      when 8
        raise BadPasswordError.new("El PIN ingresado es inválido, si olvidaste tu pin, llama al *555 o contáctate con soporte directamente desde la App Tigo Money, si tu saldo es mayor a Bs 313, debes pasar por un of. Tigo con tu carnet")
      when 11
        raise PasswordInputTimeoutError.new("El tiempo para introducir tu contraseña se agotó, por favor intenta iniciar la transacción nuevamente.")
      when 14
        raise TargetNotRegisteredError.new("Esta cuenta no está habilitada para operar con Tigo Money, regístrate marcando *555# o descarga la App Tigo Money a tu celular. Mas info llama al *555, o contáctate con soporte directamente desde la App Tigo Money")
      when 16
        raise TargetSuspendedError.new("Cuenta Tigo Money suspendida, por favor comunícate al *555, o contáctate con soporte directamente desde la App Tigo Money para resolver este problema")
      when 17
        raise InvalidAmountError.new("El monto solicitado no es válido. Verifica los datos ingresados.")
      when 19
        raise AgentBlacklistedError.new("#{commerce_name} no está habilitado para operar con TigoMoney. Contactate a #{support_email} para resolver este problema")
      when 23
        raise AmountTooSmallError.new("El monto solicitado es inferior al mínimo permitido. Por favor, verifica los datos ingresados.")
      when 24
        raise AmountTooBigError.new("El monto solicitado es superior al máximo permitido. Por favor, verifica los datos ingresados.")
      when 560
        raise SameOriginSameAmountError.new("Estimado cliente tu transaccion no pudo ser completada, por favor intenta nuevamente.")
      when 1001
        raise InsufficientFundsError.new("Tu saldo es insuficiente para completar la transaccion, carga tu cuenta desde la web de tu banco, desde un cajero Tigo Money ó desde un Punto más cercano a ti, marcando *555# o ingresando a la App Tigo Money.")
      when 1002
        raise TransactionRecoveredError.new("Ingresa a Completa tu transaccion desde la App Tigo Money o marcando *555#, Si olvidaste tu PIN, llama al *555, o contáctate con soporte directamente desde la App Tigo Money. Si tu saldo es mayor a Bs 313, debes pasar por un of. Tigo con tu carnet")
      when 1004
        raise WalletCapExceededError.new("Estimado cliente, llegaste al límite maximo para realizar transacciones, para consultas por favor llama al *555, o contáctate con soporte directamente desde la App Tigo Money. También puedes pasar por una Of. Tigo con tu Carnet.")
      when 1012
        raise PasswordRetryExceededError.new("Estimado Cliente excediste el límite de intentos para introducir tu PIN, por favor comunícate con el *555 para solicitar nuevo PIN, o contáctate con soporte directamente desde la App Tigo Money, si tu saldo es mayor a Bs 313, debes pasar por una of. Tigo con tu Carnet.")
      when 9999
        raise UtibaUnreachableError.new("El servidor de TigoMoney está experimentando algún tipo de inconveniente. Por favor, intentar más tarde o comunicate con el soporte en #{support_email}")
      end
    end
  end
end