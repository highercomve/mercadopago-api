require File.join(File.dirname(__FILE__), '../lib/', 'mercadopagoapi.rb') 
require 'rspec'

# setup test environment

class MercadopagoTest < Mercadopago::Mp 
  CREDENTIALS = {
    :client_id => "your-client-id",
    :client_secret => "your-client-secret"
  }

  CONFIG = {
    :currency_id => "VEF",
    :sandbox => false
  }
end

