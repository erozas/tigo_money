module TigoMoney
  class Status
    class << self
      def check order_id
        Client.new().execute_request(:consultar_estado, order_id.to_s)
      end
    end
  end  
end