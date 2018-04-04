module TigoMoney
	# Encapsulates the response that came back from Savon
	class Response
		# The body of the response as sent by the TigoMoney API
		attr_accessor :raw_body

		# The effective body of the response, as a result of accessing the hash
		# using a key composed of the operation_key + "_response"
		attr_accessor :body
		
		# The headers of the HTTP response
		attr_accessor :http_headers

		# The status code given by the response. Basically useless as it always
		# default to 200 OK
		attr_accessor :http_status
		
		def self.from_savon(response)
			resp = Response.new
			resp.raw_body			= response.body
			resp.http_headers = response.http.headers
			resp.http_status  = response.http.code 
			resp
		end
	end
end
