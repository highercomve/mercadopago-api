require File.join(File.dirname(__FILE__), '../lib/', 'mercadopagoapi.rb') 
require 'rspec'

# setup test environment
class MercadopagoTest < Mercadopago::Mp	
	CREDENTIALS = {
		:client_id => "656576577657655765",
		:client_secret => "sddfjjsdjfksdjfhskhf76547467546"
	}

	CONFIG = {
		:currency_id => "VEF",
		:sandbox => true
	}
end

