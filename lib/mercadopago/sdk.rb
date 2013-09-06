require 'rubygems'
require 'rest_client'
require 'json/add/core'
require 'uri'

module Mercadopago
	class Sdk

		attr_accessor :client_id, :client_secret, :sanbox, :currency, :checkout
		attr_writer :access_token
		
		def initialize(client_id=nil, client_secret=nil, currency=nil, sanbox=false)
			@client_id = client_id || "5453328363694708"
			@client_secret = client_secret || "wxO9sB8Mer7wFzrjHUHLHC3iGygc4zgm"
			@sanbox = sanbox
		end

		def get_access_token
			url = "/oauth/token"
			data = {
				:grant_type => "client_credentials",
				:client_id => @client_id,
				:client_secret => @client_secret
			}
			result = Rest::exec(:post, url, data)
			if result[:status] == 200
			  @access_token = result[:response]["access_token"] 
			end
		end

		def access_token
			@access_token || get_access_token
		end

		def create_checkout_preference(data, exclude_methods=nil)
			unless exclude_methods.nil?
				data[:payment_methods] = { 
					:excluded_payment_methods => exclude_methods
				}
			end
			url = "/checkout/preferences?access_token="+access_token
			result = Rest::exec(:post, url, data, true)
			if result[:status] = 201
				@checkout = result[:response]
			else
				result
			end
		end

		def get_payment_info(id)
      
		end
	end

	module Rest
		URL = "https://api.mercadolibre.com/"

		def exec(method, url, data=nil, json=false)	
			url = uri(url)
			if json
				RestClient.send(method, url, data.to_json, :content_type => :json, :accept => :json) do |response, request, result|
					{
						:status => response.code,
						:response => JSON.parse(response)
					}
				end
			else
				RestClient.send(method, url, data) do |response, request, result|
					{
						:status => response.code,
						:response => JSON.parse(response)
					}
				end
			end
		end
		
		def uri(url)
			URI.join(URL, url).to_s
		end
		
		module_function :exec, :uri
	end
end
