# Mercadopago::Api

This is a Gem to manage mercadopago using ruby, you can use the Gem like a simple Sdk to mercadopago api or like a extension module with another options.

## Installation

Add this line to your application's Gemfile:

	gem 'mercadopago-api'

And then execute:

	$ bundle install

Or install it yourself as:

	$ gem install mercadopago-api

## Usage

The gem has to ways of use it, the basic way like a normal SDK

### Usage like SDK

For normal use
		
	mp_client = Mercadopago::Sdk.new(client_id, client_secret)
		
Accept a optional parameter true or false to activate sandbox mode
		
	sandbox_client = Mercadopago::Sdk.new(client_id, client_secret, true)

#### Manage Preference

Create a checkout preference to create a link to mercadopago checkout

	preference = mp_client.create_checkout_preference(data)

Data format is describe [here](http://developers.mercadopago.com/documentacion/api/preferences#glossary)

The minimal hash for data is:

	data = {
		:items => [
			{ 
				:title => "Title of product",
				:currency_id => "VEF", 
				:unit_price => 2000.50,
				:quantity => 2,
			}
		]
	}

The api response wil gave this format, will be a ruby hash and the key values will be like string not like symbols

	{
		"code": 200,
		"external_reference": "Reference_1234",
		"items": [
			{
				"id": "Code",
				"title": "Title of what youre paying for",
				"description": "Description",
				"quantity": 1,
				"unit_price": 50.5,
				"currency_id": "Currency",
				"picture_url": "https://www.mercadopago.com/org-img/MP3/home/logomp3.gif"
			}
		],																																				    "date_created": "2011-08-16T21:28:42.606-04:00",
		"id": "preference_identifier",
		"collector_id": "your_ID_as_seller",
		"init_point": "checkout-access-URL",
		"payer": {
			"email": "payer@email.com",
			"name": "payer-name",
			"surname": "payer-surname"
		},
		"back_urls": {
			"success": "https://www.success.com",
			"failure": "http://www.failure.com",
			"pending": "http://www.pending.com"
		},
		"payment_methods": {
			"excluded_payment_methods": [
				{
				"id": "amex"
				}
			],
			"excluded_payment_types": [
				{
					"id": "ticket"
				}
			],
			"installments": 12
		}	
	}

If you have to search a previus create preference

	preference = mp_client.get_checkout_preference(preference_id)

If you have to update a Preference

	preference = mp_client.update_checkout_preference(preference_id, new_data)

Get a notification (IPN) payment info, details [here](http://developers.mercadopago.com/documentation/instant-payment-notifications)

	payment = mp_client.get_payment_info(notificaion_payment_id)

This will return and object like this:

	{
		code: 200,
		collection: {
			id: 52675155,
			site_id: "Country ID",
			operation_type: "regular_payment",
			order_id: "4442154",
			external_reference: "150671633",
			status: "approved",
			status_detail: "accredited",
			payment_type: "ticket",
			date_created: "2011-09-02T04:00:000Z",
			last_modified: "2011-09-12T02:52:530Z",
			date_approved: "2011-09-02T02:49:530Z",
			money_release_date: "2011-09-09T02:49:530Z",
			currency_id: "Currency",
			transaction_amount: 50.5,
			shipping_cost: 0,
			finance_charge: null,
			total_paid_amount: 50.5,
			net_received_amount: 0,
			reason: "Title of what youre paying for",
			payer: {
				id: 36073078,
				first_name: "payer-name",
				last_name: "payer-surname",
				email: "payer@email.com",
				nickname: "payer-MercadoLibre's-nickname"
				phone: {
					area_code: "011",
					number: "3486 5039",
					extension: null
				}
			},
			collector: {
				id: 68961616,
				first_name: "collector-name",
				last_name: "collector-surname",
				email: "collector@email.com",
				nickname: "collector-MercadoLibre's-nickname"
				phone: {
					area_code: "211",
					number: "3486 5039",
					extension: null
				}
			}
		}
	}

Search a payment by payment_id, you can get that when you set your back_urls on checkout Preference, the api will send using query string parameters to your back_url (the api will responde in this case a parameter call collection_id == payment_id)

	payment = mp_client.search_payment(payment_id)

The response for a payment search is:

	{
	id: id-del-pago,
    	site_id: "Identificador de país",
    	date_created: "2011-12-25T12:16:45.000-04:00",
    	date_approved: "2011-12-25T12:16:45.000-04:00",
    	last_modified: "2011-12-25T12:16:55.000-04:00",
    	collector_id: id-del-vendedor,
   		payer: {
        	id: 36073078,
        	email: "payer@email.com"
    	}
    	order_id: "id-orden",
    	external_reference: null,
   		reason: "Título de lo que estás pagando",
    	transaction_amount: 40,
    	currency_id: "Tipo de moneda",
    	total_paid_amount: 40,
    	shipping_cost: 0,
    	net_received_amount: 38,
    	status: "approved",
    	status_detail: "accredited",
    	released: "yes",
    	payment_type: "credit_card",
    	installments: 1,
    	money_release_date: "2011-12-27T12:16:45.000-04:00",
    	operation_type: "regular_payment"
	}

Search in all your payments given a hash, this hash will set your search parameters. For more details of what parameters you can use to search look [here](http://developers.mercadopago.com/documentation/search-received-payments#search-filters)

	search_query = { :id => "13232333" } 
	payments = mp_client.search_payments_where( search_query )
	
	# Search by status
	search_query = { :status => "approved" }
	payments = mp_client.search_payments_where( search_query )

the response of that will be:

	{
		paging: {
			total: 76,
			limit: 2,
			offset: 10
		},
		results: [
			collection ## one array of collection, see previus response code
		]
	}

Refund Payment, return the money to the original payer

	refund = mp_client.refund_payment(payment_id)

Cancel Payment

	cancel = mp_client.cancel_payment(payment_id)

Create recurrent payment (preapproval payment)

This method create a preapproval payment (recurrent payment). Recive a data hash with this structure

	data = {
	  payer_email: String,
	  back_url: String, 
	  reason: String,
	  external_reference: String,
	  auto_recurring: {
	    frecuency: Number,
	    frequency_type: String,  // months or days
	    transaction_amount: Number,
	    currency_id: String,
	    start_date,
	    end_date
	  }

For more information about avaliable options go to [here](http://developers.mercadopago.com/documentation/glossary/recurring-payments)
 
	preapproval_payment = mp_client.create_preapproval_payment(data)

Get a recurrent payment information

This method get all the information about a recurrent payments. for more information about what return this method go to [here](http://developers.mercadopago.com/documentation/glossary/recurring-payments#!/get)
    
	preapproval_payment = mp_client.get_preapproval_payment(id)
	
### Usage like extension 

TODO: write this

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
