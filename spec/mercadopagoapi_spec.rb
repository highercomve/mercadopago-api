require 'spec_helper'

describe 'Test Mercadopago Api Object' do
	before do
		@credenciales = MercadopagoTest::CREDENTIALS
	end

	it "The object must initialize only with credentials" do
		api = MercadopagoTest.new(@credenciales[:client_id], @credenciales[:client_secret])
		api.should be_kind_of(Mercadopago::Mp)
	end

end

describe 'Mercado Pago api' do
	before do
		@credenciales = MercadopagoTest::CREDENTIALS
		@api = MercadopagoTest.new(@credenciales[:client_id], @credenciales[:client_secret])
	end

	it "The object must initialize only with credentials" do
		@api.should be_kind_of(Mercadopago::Mp)
		@api.credentials.should == @credenciales
	end

	it "The sdk most have a token to work" do
		@api.sdk.access_token.should_not be_nil
	end

	it "The object most accept config values" do
		config = { :currency_id => "VEF", :sandbox => true }
		@api.config = config 
		@api.config.should == config
	end
end
