require_relative "./mercadopago/api"
require_relative "./mercadopago/version"

module Mercadopago
  class Mp
    include Api

    def initialize(client_id, client_secret)
      set_credentials(client_id, client_secret)
    end
    
  end
end
