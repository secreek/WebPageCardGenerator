require 'uri'
require 'net/http'

module URI

	# Redirected max as 5 times.
	LIMITIED = 5

	def self.html_get_web_uri uri, count = 0
		return nil if count >= LIMITIED
		response = Net::HTTP.get_response(URI.parse(uri))
		case (response)
		when Net::HTTPSuccess
			return uri
		when Net::HTTPRedirection 
			return html_get_web_uri(response['Location'], count + 1)
		else
			return nil
		end
	end
end
