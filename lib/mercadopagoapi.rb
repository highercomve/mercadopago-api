require "mercadopago/api"
require "mercadopago/version"

module Mercadopago
  class Mp
    include Api

    def initialize(client_id, client_secret)
      set_credentials(client_id, client_secret)
    end
    
  end
end
