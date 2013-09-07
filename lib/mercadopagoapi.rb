require_relative "./mercadopago/sdk"
require_relative "./mercadopago/version"

module Mercadopago
	module Api
		attr_writer :credentials, :preference
		attr_reader :sdk
		
		def checkout_link(data)
			preference = sdk.create_checkout_preference(data, config[:excluded_payment_methods])
			if config[:sandbox].nil?
				preference['init_point']
			else
				preference['sandbox_init_point']
			end
		end

		def sdk
			@sdk ||= Sdk.new(credentials[:client_id], credentials[:client_secret], config[:sandbox])
		end

		def credentials
			raise "Please set yours Credentials, using set_credentials" if @credentials.empty?
			@credentials
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


		# CONFIG HASH
		# {
		# :currency_id ,
		# :site_id,
		# :sandbox,
		# :back_urls => {
  	#   "success": "https://www.success.com",
  	#   "failure": "http://www.failure.com",
  	# 	"pending": "http://www.pending.com"
  	# },
  	# :excluded_payment_methods => [
   	#  	{
   	#   	"id": "amex"
   	# 	}
   	#  ]
   	# }
