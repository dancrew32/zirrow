require 'httparty'
class ZirrowRentals
	include HTTParty
	@@base = 'http://api.rentalapp.zillow.com/'
	base_uri @@base

	attr_accessor :apis, :github

	def initialize options={}
		require 'json'
		@options = {
			:key => '',
			:docs => 'http://api.rentjuice.com/documentation/rentJuice_API.pdf'
		}.merge options

		@apis = {
			'ads' => {
				desc: "Retrieve ads that are in all of your office's users' queues"
			},
			'ads_update' => {
				desc: "Change the status or remove an ad from the ad queue"
			},
			'buildings' => {
				desc: "Retrieve basic information about buildings within your Zillow Rentals account"
			},
			'features' => {
				desc: "retrieve all features your office has defined within your Zillow Rentals account"
			},
			'landlords' => {
				desc: "retrieve basic information about landlords within your Zillow Rentals account"		
			},
			'leads' => {
				desc: "retrieve basic information about leads within your Zillow Rentals account"
			},
			'leads_add' => {
				desc: "add a new lead into your office's database"
			},
			'listings' => {
				desc: "retrieve listings that match your search.listings"	
			},
			'listings.custom_fields' => {
				desc: "retrieve a list of custom fields your office has set up for listings"
			},
			'neighborhoods' => {
				desc: "retrieve all neighborhoods your office has defined within your Zillow Rentals account"
			},
			'profile' => {
				desc: "retrieve basic information about your account"
			},
			'terms' => {
				desc: "retrieve all rental terms your office has defined within your Zillow Rentals account"
			},
		}
		
		@github = 'https://github.com/dancrew32/zirrow'
	end

	# DEMOGRAPHICS
	def listings o={}
		o = {
			'regionId'     => nil,
			'state'        => nil,
			'city'         => nil,
			'neighborhood' => nil,
			'zip'          => nil,
		}.merge o

		req __method__, o
	end


	def req api, body
		section = @apis[api.to_s][:section] ? ("#{@apis[api.to_s][:section]}/") : ''

		url = "/#{section}#{@apis[api.to_s][:url]}.htm"
		self.class.post url, :body => body
	end

	def is_a_number? s
		  s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
	end
end
