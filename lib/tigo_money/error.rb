module TigoMoney
	# The base class from which every other error inherits
	# its behaviour. It contains the error message and information about the
	# response that triggered it
	class Error < StandardError
		attr_accessor :response, :code

		attr_reader :http_header, :http_body, :message

		def initialize(message = nil,  http_body = nil, http_headers = nil, 										json_body = nil) 
			@message = message
			@http_body  = http_body
			@http_headers = http_headers || {}
		end
	end

	##### AUTHORIZATION ERRORS
	
	# Should be raised when an Unauthorized Request is made
	# Code: 7
	class AccessDeniedError < Error
	end
	
	# Should be raised when the commerce has been
	# blacklisted from operating with TigoMoney
	# Code: 19
	class AgentBlacklistedError < Error
	end

	# Should be raised when the commerce isn't 
	# allowed/registered to process TigoMoney transactions
	# Code: 4
	class AgentNotRegisteredError < Error
	end

	# Should be raised when the client enters a
	# wrong PIN.
	# Code: 8
	class BadPasswordError < Error
	end

	# Should be raised when the time taken to input the
	# password exceeds the maximum amount of time permitted by Tigo
	# Code: 11
	class PasswordInputTimeoutError < Error
	end
	
	# PasswordRetryExceeded should be raised when the users has
	# exceeded the maximum amount of password retries
	# Code: 1012
	class PasswordRetryExceededError < Error
	end
	
	# The users account is not registered with the TigoMoney
	# service, meaning it can't complete the transaction
	# Code: 14
	class TargetNotRegisteredError < Error
	end

	# The users account was registered with the TigoMoney
	# service but it has been suspended.
	# Code: 16
	class TargetSuspendedError < Error
	end

	##### TRANSACTION ERRORS

	# Should be raised when the order amount is larger than the
	# maximum amount that's permitted buy the TigoMoney API
	# Code: 24
	class AmountTooBigError < Error
	end

	# Should be raised when the order amount is lower than the
	# minimum amount permitted by the TigoMoney API
	# Code: 23
	class AmountTooSmallError < Error
	end

	# Should be raised when the total amount
	# of the transaction is invalid,
	# Code: 17
	class InvalidAmountError < Error
	end

	# Should be raised when there's two consecutive requests
	# for the same origin and the same amount within one minute
	# Code: 560
	class SameOriginSameAmountError < Error
	end

	# Should be raised when the client doesnt have sufficient funds
	# in its account
	# Code: 1001
 	class InsufficientFundsError < Error
	end	

	# Should be raised when a transaction is feasable but it didn't
	# went completely true. The user should see a message with instructions
	# on how to complete the transaction.
	# Code: 1002
	class TransactionRecoveredError < Error
	end

	# Should be raised when the client has reached the maximum number
	# of transactions allowed by his wallet
	# Code: 1004
	class WalletCapExceededError < Error
	end

	class WalletBalanceExceededError < Error
	end
	
	##### CONNECTION ERRORS
	
	# Should be raised when the connection with the Sutiba endpoint
	# is not possible
	# Code: 9999
	class SutibaUnreachableError < Error
	end
	
	# Code: 39
	class TargetStoppedError < Error
	end

	# Should be raised when the connection has timed out
	class TimeOutError < Error
	end
end