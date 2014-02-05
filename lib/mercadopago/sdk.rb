require 'rest_client'
require 'json/ext'
require 'uri'

module Mercadopago
  class Sdk

    attr_accessor :client_id, :client_secret, :sandbox
    
    def initialize(client_id, client_secret, sandbox=false)
      @client_id = client_id 
      @client_secret = client_secret
      @sandbox = sandbox
    end

    def get_access_token
      url = "/oauth/token"
      data = {
        :grant_type => "client_credentials",
        :client_id => @client_id,
        :client_secret => @client_secret
      }
      result = Rest::exec(:post, url, data)
    end

    def access_token
      @access_token ||= get_access_token["access_token"]
    end

    def create_checkout_preference(data, exclude_methods=nil)
      unless exclude_methods.nil?
        data[:payment_methods] = { 
          :excluded_payment_methods => exclude_methods
        }
      end
      url = "/checkout/preferences?access_token="+access_token
      Rest::exec(:post, url, data, true)
    end

    def update_checkout_preference(preference_id, data)
      url = build_url "/checkout/preferences/#{preference_id}"
      Rest::exec(:put, url, data, true)
    end

    def get_checkout_preference(id)
      url = build_url "/checkout/preferences/#{preference_id}"
      Rest::exec(:get, url, nil, true)
    end

    # This method create a preapproval payment (recurrent payment)
    # Recive a data hash with this structure:
    #
    # data = {
    #   payer_email: String,
    #   back_url: String, 
    #   reason: String,
    #   external_reference: String,
    #   auto_recurring: {
    #     frecuency: Number,
    #     frequency_type: String,  // months or days
    #     transaction_amount: Number,
    #     currency_id: String,
    #     start_date,
    #     end_date
    #   }
    #
    # For more information about avaliable options go to 
    # http://developers.mercadopago.com/documentation/glossary/recurring-payments
   def create_preapproval_payment(data)
      url = "/preapproval?access_token="+access_token
      Rest::exec(:post, url, data, true)
    end

    # This method get all the information about a recurrent payment
    # for information about what return this method go to 
    # http://developers.mercadopago.com/documentation/glossary/recurring-payments#!/get
    def get_preapproval_payment(id)
      url = "/preapproval/#{id}"
      Rest::exec(:get, url)
    end

    def get_payment_info(notification_id)
      url = build_url "/collections/notifications/#{notification_id}"
      Rest::exec(:get, url, nil, true)
    end

    def search_payment(payment_id)
      url = build_url "/collections/#{payment_id}"
      Rest::exec(:get, url, nil, true)
    end

    def search_payments_where(params)
      url = build_url "/collections/search", false
      params[:access_token] = access_token 
      Rest::exec(:get, url, { :params => params })		
    end 

    def create_test_user(site_id)
      url = build_url "users/test_user"
      Rest::exec(:post, url, { :site_id => site_id }, true )
    end

    def refund_payment(payment_id)
      url = build_url "/collections/#{payment_id}"
      Rest::exec(:put, url, {:status => "refunded"}, true )
    end

    def cancel_payment(payment_id)
      url = build_url "/collections/#{payment_id}"
      Rest::exec(:put, url, {:status => "cancelled"}, true )
    end

    def build_url(action, token=true)
      if token
        sandbox_prefix + action + "?access_token=#{access_token}"
      else
        sandbox_prefix + action
      end
    end

    def sandbox_prefix 
      @sandbox ? "/sandbox":""
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
      else 
        RestClient.send(method, url, data) do |response, request, result|
          build_response(response)
        end
      end 
    end
    
    def build_response( response )
      r = JSON.parse(response.force_encoding("UTF-8"))
      r[:code] = response.code
      return r
    end

    def uri(url)
      URI.join(URL, url).to_s
    end
    
    module_function :exec, :uri, :build_response
  end
end
