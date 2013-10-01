require "mercadopago/sdk"
:w
module Mercadopago
  module Api
    attr_writer :credentials, :preference
    attr_reader :sdk
    
    def checkout_link(data)
      preference = sdk.create_checkout_preference(data, config[:excluded_payment_methods])
      if config[:sandbox]
        preference['sandbox_init_point']
      else
        preference['init_point']
      end
    end

    def find_payment(payment_id)
      if config[:sandbox]
        result = sdk.search_payments_where({:id => payment_id})['results'].first
      else
        result = sdk.search_payment(payment_id)
      end
      result
    end

    def find_payment_with_notification(payment_id)
      result = sdk.get_payment_info(payment_id)
      payment = result['collection']
      payment[:code] = result[:code]
    end

    def sdk
      @sdk ||= Sdk.new(credentials[:client_id], credentials[:client_secret], config[:sandbox])
    end

    def credentials
      if @credentials.empty?
        raise "Please set yours Credentials, using set_credentials"
      else
        @credentials
      end
    end

    def preference
      if @preference.nil?
        raise "You have to create or get a preference first" 
      else
        @preference
      end
    end

    def config
      @config || {}
    end

    def config=(config)
      @config = config
    end

    def set_credentials(client_id, client_secret)
      @credentials = {
        :client_id => client_id,
        :client_secret => client_secret
      }
    end
  end

end
  
