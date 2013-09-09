require File.join(File.dirname(__FILE__), '../lib/', 'mercadopagoapi.rb') 
require 'rspec'

# setup test environment
class MercadopagoTest < Mercadopago::Mp	
	CREDENTIALS = {
<<<<<<< HEAD
		:client_id => "5453328363694708",
		:client_secret => "wxO9sB8Mer7wFzrjHUHLHC3iGygc4zgm"
=======
		:client_id => "656576577657655765",
		:client_secret => "sddfjjsdjfksdjfhskhf76547467546"
>>>>>>> master
	}

	CONFIG = {
		:currency_id => "VEF",
		:sandbox => true
	}
end

