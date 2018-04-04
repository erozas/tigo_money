require 'base64'
require 'json'
require 'mcrypt'
require 'openssl'
require 'savon'

require 'tigo_money/charge'
require 'tigo_money/client'
require 'tigo_money/configuration'
require 'tigo_money/encryptor'
require 'tigo_money/decryptor'
require 'tigo_money/errors'
require 'tigo_money/formatter'
require 'tigo_money/response'
require 'tigo_money/status'
require 'tigo_money/version'

require 'tigo_money/async_payment_response'
require 'tigo_money/status_check_response'
require 'tigo_money/sync_payment_response'


module TigoMoney
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
