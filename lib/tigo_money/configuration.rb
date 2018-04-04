module TigoMoney
  class Configuration
    # The endpoint that the TigoMoney::Client uses to set the URL it 
    # makes requests to. The endpoint is expected to contain a WSDL document
    # Defaults to: nil
    # @return [String]
    attr_accessor :api_endpoint

    attr_accessor :available_operations

    # The name of the commerce that shows up in the confirmation message
    # that Tigo sends to ther user making the payment.
    # Defaults to: nil
    # @return [String]
    attr_accessor :commerce_name

    # The algorithm that is used to decrypt the response sent
    # by the TigoMoney API. By default, TigoMoney expects the communications
    # to be encrypted using the des-ede3 algorithm
    # Defaults to: "des-ede3"
    # @return [String]
    attr_accessor :decryption_algorithm

    # The algorithm used by the library to encrypt the formatted
    # params before sending them to the TigoMoney API. By default, TigoMoney
    # expects the communications to be encrypted/decrypted using the des-ede3 algorithm
    # Defaults to: "des-ede3"
    # @return [String]
    attr_accessor :encryption_algorithm

    # The cryptographic key used to encrypt and decrypt every communication
    # with the TigoMoney API
    # Defaults to: nil
    # @return [String]
    attr_accessor :encryption_key
    
    # A config param that's passed to the Savon client initialization process.
    # The presence of the param with the value ":none" signals that we want to
    # disable SSL verification
    # Defaults to: nil
    # @return [Symbol | String]
    attr_accessor :ssl_verify_mode

    # The host applications support email. It is shown when some errors are raise
    # so the client knows where to ask the appropiate questions
    attr_accessor :support_email
    
    # A 128 character identifier that allows us to authenticate as valid
    # consumers of the TigoMoney API.
    # Defaults to: nil
    # @return [String] 
    attr_accessor :tigo_money_id
  
    def initialize
      @api_endpoint         = nil
      @available_operations = nil
      @commerce_name        = nil
      @decryption_algorithm = 'des-ede3'
      @encryption_algorithm = 'des-ede3'
      @encryption_key       = nil
      @payment_description  = nil
      @ssl_verify_mode      = nil
      @support_email        = nil
      @tigo_money_id        = nil
    end
  end
end
