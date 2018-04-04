module TigoMoney
  class Decryptor
    class << self
      def decrypt(message)
        cipher = Mcrypt.new("tripledes", :ecb, TigoMoney.configuration.encryption_key, nil, :pkcs)
        cipher.decrypt(base_64_decode(message)).gsub("\x00", '')
      end
  
      private
      def base_64_decode(message)
        Base64.decode64(message)
      end
    end
  end
end