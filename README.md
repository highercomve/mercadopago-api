# Mercadopago::Api

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'mercadopago-api'

And then execute:

    $ bundle

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

Get a notification (IPN) payment info, details [here]{http://developers.mercadopago.com/documentation/instant-payment-notifications}

		payment = mp_client.get_payment_info(notificaion_payment_id)

Search a payment by payment_id, you can get that when you set your back_urls on checkout Preference, the api will send using query string parameters to your back_url (the api will responde in this case a parameter call collection_id == payment_id)

		payment = mp_client.search_payment(payment_id)

The response for a payment search is:

		{
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

Search in all your payments given a hash, this hash will set your search parameters. For more details of what parameters you can use to search look [here](http://developers.mercadopago.com/documentation/search-received-payments#search-filters)

		search_query = { :id => "13232333" } 
		payments = search_payments_where( search_query )
		
		# Search by status
		search_query = { :status => "approved" }
		payments = search_payments_where( search_query )

the response of that will be:

		{
		  paging: {
			  total: 76,
				limit: 2,
				offset: 10
			},
			results: [
				collention ## one array of collection, see previus response code
			]
		}

TODO: refund_payment

TODO: cancel_payment

### Usage like extension 

TODO: write this

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
