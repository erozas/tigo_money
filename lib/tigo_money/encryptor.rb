module TigoMoney
  # In charge of encrypting the message to be sent to the TigoMoney API.
  # As 
  class Encryptor
    BLOCK_LENGTH = 8
   
    def self.encrypt(message)
      cipher = OpenSSL::Cipher.new(TigoMoney.configuration.encryption_algorithm)
      cipher.padding = 0
      cipher.encrypt
      message += "\0" until message.bytesize % BLOCK_LENGTH == 0
      cipher.key = TigoMoney.configuration.encryption_key
      encrypted = cipher.update(message) + cipher.final
      Base64.encode64(encrypted).gsub("\n", '')
    end
  end
end