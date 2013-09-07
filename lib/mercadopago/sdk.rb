require 'rubygems'
require 'rest_client'
require 'json/ext'
require 'uri'

module Mercadopago
	class Sdk

		attr_accessor :client_id, :client_secret, :sanbox, :currency, :checkout
		attr_writer :access_token
		
		def initialize(client_id=nil, client_secret=nil, sanbox=false)
			@client_id = client_id 
			@client_secret = client_secret
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
			if result[:code] == 200
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
			response = Rest::exec(:post, url, data, true)
			if response[:code] = 201
				@checkout = response[:response]
			else
				response
			end
		end

		def update_checkout_preference(preference_id, data)
			url = sandbox_prefix + "/checkout/preferences/#{preference_id}?access_token=#{access_token}"
			response = Rest::exec(:put, url, data, true)
		end

		def get_checkout_preference(id)
			url = sandbox_prefix + "/checkout/preferences/#{preference_id}?access_token=#{access_token}"
			response = Rest::exec(:get, url, nil, true)
		end

		def get_payment_info(notification_id)
			url = sandbox_prefix + "/collections/notifications/#{notification_id}?access_token=#{access_token}"
			Rest::exec(:get, url, nil, true)
		end

		def search_payment(payment_id)
			url = sandbox_prefix + "/collections/#{payment_id}?access_token=#{access_token}"
			Rest::exec(:get, url, nil, true)
		end	

		def create_test_user(site_id)
			url = "users/test_user?access_token=#{access_token}"
			Rest::exec(:post, url, { :site_id => site_id }, true )
		end

		def refund_payment(payment_id)
			url = "/collections/#{payment_id}?access_token=#{access_token}"
			Rest::exec(:put, url, {:status => "refunded"}, true )
		end

		def cancel_payment(payment_id)
			url = "/collections/#{payment_id}?access_token=#{access_token}"
			Rest::exec(:put, url, {:status => "cancelled"}, true )
		end

		def sandbox_prefix 
			@sanbox ? "/sandbox":"":
		end

	end

	module Rest
		URL = "https://api.mercadolibre.com/"
		def exec(method, url, data=nil, json=false)	
			url = uri(url)
			if !data.nil? and json
				RestClient.send(method, url, data.to_json,  :content_type => :json, :accept => :json) do |response, request, result|
					build_response(response)
				end
			elsif data.nil? and json
				RestClient.send(method, url, :accept => :json) do |response, request, result|
					build_response(response)
				end
			#elsif data.nil? and !json
			#	RestClient.send(method, url) do |response, request, result|
			#		build_response(response)
			#	end
			else 
				RestClient.send(method, url, data) do |response, request, result|
					build_response(response)
				end
			end	
		end
		
		def build_response( response )
			{
				:code => response.code,
				:response => JSON.parse(response.force_encoding("UTF-8"))
			}
		end

		def uri(url)
			URI.join(URL, url).to_s
		end
		
		module_function :exec, :uri, :build_response
	end
end
