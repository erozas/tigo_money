module TigoMoney
  class Charge
    class << self
      def create_sync(plain_params)
        Client.new.execute_request("solicitar_pago", plain_params)
      end
  
      def create_async(plain_params)
        Client.new().execute_request("solicitar_pago_asincrono", plain_params)
      end
    end
  end
end