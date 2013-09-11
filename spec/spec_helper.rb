require File.join(File.dirname(__FILE__), '../lib/', 'mercadopagoapi.rb') 
require 'rspec'

# setup test environment
class MercadopagoTest < Mercadopago::Mp	
	CREDENTIALS = {
		:client_id => "5453328363694708",
		:client_secret => "wxO9sB8Mer7wFzrjHUHLHC3iGygc4zgm"
	}

	CONFIG = {
		:currency_id => "VEF",
		:sandbox => false
	}
end

