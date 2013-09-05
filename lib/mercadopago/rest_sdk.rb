require 'rubygems'
require 'curb'
require 'json/add/core'
require 'uri'

module Mercadopago
	class Api
		
		attr_accessor :client_id, :client_secret, :sanbox, :currency
		attr_writer :access_token
		
		def initialize(client_id=nil, client_secret=nil, currency=nil, sanbox=false)
			@client_id = client_id || "5453328363694708"
			@client_secret = client_secret || "wxO9sB8Mer7wFzrjHUHLHC3iGygc4zgm"
			@sanbox = sanbox
		end

		def get_access_token
			url = "/oauth/token"
			data = {
				'grant_type' => 'client_credentials',
				'client_id' => @client_id,
				'client_secret' => @client_secret
			}
			result = RestClient::exec(:post, "/oauth/token", data)
			if result[:status] == "200 OK"
				@access_token = result[:response]["access_token"] 
			end
		end

		def access_token
			@access_token || get_access_token
		end

		def create_checkout_preference(data)
			url = "/checkout/preferences?access_token="+access_token
			result = RestClient::exec(:post, url, data)
			result[:response]
		end

		def get_payment_info(id)

		end
	end

	module RestClient
		URL = "https://api.mercadolibre.com/"

		def exec(method, rute, data=nil)
			url = uri(rute)
			http = Curl.send(method, url, data)
			{
				:status => http.status,
				:response => JSON.parse(http.body_str)
			}
		end

		def uri(rute)
			URI.join(URL, rute).to_s
		end
		module_function :exec, :uri
	end

end