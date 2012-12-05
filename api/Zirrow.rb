require 'httparty'
class Zirrow
	include HTTParty
	base_uri 'http://www.zillow.com/webservice'

	attr_accessor :apis

	def initialize options={}
		require 'json'
		@options = {
			:key => '',
			:how => 'http://www.zillow.com/howto/api'
		}.merge options

		@apis = {
			'demographics' => {
				:url     => 'GetDemographics',
				:example => "@z.demographics 'zip' => 94121",
			},
			'search' => {
				:url     => 'GetSearchResults',	
				:example => "@z.search 'address' => '184 17th ave', 'citystatezip' => 'san francisco ca'",
			},
			'zestimate' => {
				:url     => 'GetZestimate',
				:example => "@z.zestimate 'zpid' => 48749425, 'rentzestimate' => true",
			},
			'chart' => {
				:url     => 'GetChart',		
				:example => "@z.chart 'zpid' => 48749425",
			},
			'comps' => {
				:url     => 'GetComps',
				:example => "@z.comps 'zpid' => 48749425",
			},
			'children' => {
				:url     => 'GetRegionChildren',
				:example => "@z.children 'state' => 'CA'",
			},
			'details' => {
				:url     => 'GetUpdatedPropertyDetails',
				:example => "@z.details 'zpid' => 48749425",
			}
		}
	end

	# DEMOGRAPHICS
	def demographics o={}
		o = {
			'regionid'     => nil,
			'state'        => nil,
			'city'         => nil,
			'neighborhood' => nil,
			'zip'          => nil,
		}.merge o

		req __method__, o
	end

	# SEARCH
	def search o={}
		o = {
			'address'       => nil, # req
			'citystatezip'  => nil, # req
			'rentzestimate' => nil,
		}.merge o

		req __method__, o
	end

	# ZESTIMATE
	def zestimate o={}
		o = {
			'zpid'          => nil, # req	
			'rentzestimate' => false,
		}.merge o

		req __method__, o
	end

	# CHART
	def chart o={}
		o = {
			'zpid'          => nil,      # req	
			'unit-type'     => 'dollar', # req 'percent'
			'width'         => nil,      # 200-600
			'height'        => nil,      # 100-300
			'chartDuration' => nil,      # '1years', '5years', '10years'
		}.merge o

		req __method__, o
	end

	# COMPS
	def comps o={}
		o = {
			'zpid'          => nil,  # req	
			'count'         => '25', # req '1-25'
			'rentzestimate' => nil,
		}.merge o

		req __method__, o
	end

	# CHILDREN
	def children o={}
		o = {
			'regionid'     => nil, # req*
			'state'        => nil, # req*
			'city'         => nil,
			'neighborhood' => nil,
			'zip'          => nil,
		}.merge o

		req __method__, o
	end

	# DETAILS
	def details o={}
		o = {
			'zpid' => nil, # req
		}.merge o

		req __method__, o
	end

	# HOW TO
	def how api
		url  = "#{@options[:how]}/#{@apis[api][:url]}.htm"
		html = get_html url
		out  = ""
		html.css('#corpright p:first').each { |n| out += n }
		out
	end

	private

	# MAKE REQUEST
	def req api, body
		body = {
			'zws-id' => @options[:key], #req
		}.merge body

		url = "/#{@apis[api.to_s][:url]}.htm"
		self.class.post url, :body => body
	end

end
